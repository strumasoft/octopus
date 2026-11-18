local json = require "json"
local param = require "param"
local property = require "property"
local exit = require "exit"
local editor = require "Editor"
local parse = require "parse"
local directory = require "Directory"
local util = require "util"
local fileutil = require "fileutil"



local externalJS = [[
  <script src="/baseline/static/ace/ace.js" type="text/javascript"></script>
  <script src="/baseline/static/js/init-baseline.js" type="text/javascript"></script>
]]


local externalCSS = [[
  <link href="/editor/static/search-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
]]


local initJSTemplate = [[
  var vars = {}

  var editor = new Widget.Editor({id: "editor"})
  var editorSearchResult = new Widget.EditorSearchResult({{files}})
  var editorSearchHeader = new Widget.EditorSearchHeader("{{title}}")

  var editorSearchTemplate = new Widget.EditorSearchTemplate({
    searchResult: editorSearchResult.html,
    editor: editor.html,
    header: editorSearchHeader.html
  })

  Widget.setHtmlToPage(editorSearchTemplate.html);

  editor.init()
  $("#directoryNavigation").css("max-height", Widget.EditorTemplate.maxHeight())
  vars.searchEditor = editor
  
  Widget.EditorSearchHeader.toggle();
]]


-- LuaJIT file:read("*all") doubles a buffer up to LJ_MAX_BUF (just under 2 GiB).
-- The last size that still fits is 1 GiB, so a larger file raises "not enough memory".
local READ_ALL_LIMIT = 1024 * 1024 * 1024
local CHUNK_SIZE = 1024 * 1024


local function isMemoryError (err)
  return type(err) == "string" and err:find("not enough memory", 1, true)
end


local function streamContainsQuery (path, query, isPlainString, isIgnoreCase)
  local file = editor.open(path)
  local found = false

  local ok, err = pcall(function ()
    if not isPlainString then
      -- A pattern may span a chunk boundary; this still finds matches that fit in one chunk.
      while true do
        local chunk = file:read(CHUNK_SIZE)
        if not chunk then break end
        if chunk:findQuery(query, 1, false, isIgnoreCase) then
          found = true
          return
        end
      end
      return
    end

    local needle = query
    local ascii = true
    if isIgnoreCase then
      require "utf8"
      ascii = string.isascii(query)
      needle = ascii and string.lower(query) or string.utf8lower(query)
    end
    if needle == "" then
      found = true
      return
    end

    local overlap = #needle - 1
    local carry = ""
    while true do
      local chunk = file:read(CHUNK_SIZE)
      if not chunk then break end
      if isIgnoreCase then
        chunk = ascii and string.lower(chunk) or string.utf8lower(chunk)
      end
      local data = carry .. chunk
      if data:find(needle, 1, true) then
        found = true
        return
      end
      if overlap > 0 and #data > overlap then
        carry = data:sub(-overlap)
      else
        carry = ""
      end
    end
  end)

  file:close()
  if not ok then error(err) end
  return found
end


local function fileContainsQuery (path, size, query, isPlainString, isIgnoreCase)
  if size and size >= READ_ALL_LIMIT then
    return streamContainsQuery(path, query, isPlainString, isIgnoreCase)
  end

  local ok, content = pcall(editor.fileContent, path)
  if not ok then
    if isMemoryError(content) then
      return streamContainsQuery(path, query, isPlainString, isIgnoreCase)
    end
    error(content)
  end

  return content and content:findQuery(query, 1, isPlainString, isIgnoreCase)
end


local function aggregateAllFilesContainingQuery (files, directoryName, query, filter, isPlainString, isFileName, isIgnoreCase, counter)
  for entry, attr in pairs(directory.entries(directoryName)) do
    if attr.mode == "file" then
      local path = attr.path
      if util.isEmpty(filter) or path:find(filter) then
        if isFileName then 
          if path:findQuery(query, 1, isPlainString, isIgnoreCase) then
            files[#files + 1] = path
          end
        else
          if fileContainsQuery(path, attr.size, query, isPlainString, isIgnoreCase) then
            files[#files + 1] = path
          end

          util.doGarbageCollection(counter, 1000) -- do collectgarbage of file contents
        end
      end
    elseif attr.mode == "directory" then
      aggregateAllFilesContainingQuery(files, attr.path, query, filter, isPlainString, isFileName, isIgnoreCase, counter)
    end
  end
end


local function replaceQuery (files, directoryName, query, replace, isPlainString, isFileName, isIgnoreCase, repository, username, password)
  for i=1,#files do
    if isFileName then
      local oldName = files[i]
      local newName = oldName:replaceQuery(query, replace, isPlainString, isIgnoreCase)

      if util.isNotEmpty(repository) and util.isNotEmpty(username) and util.isNotEmpty(password) then
        local repo = require(repository)
        repo.move(username, password, oldName, newName, directoryName)
      else
        editor.rename(oldName, newName)
      end
    else
      local ok, content = pcall(editor.fileContent, files[i])
      if not ok then
        if not isMemoryError(content) then error(content) end
      elseif content then
        local newContent = content:replaceQuery(query, replace, isPlainString, isIgnoreCase)

        if newContent then
          editor.save(files[i], newContent)
        end
      end
    end
  end
end


local function process ()
  local directoryName = param.directoryName
  local query = param.query
  local replace = param.replace
  local filter = param.filter
  local isRegex = util.toboolean(param.isRegex)
  local isFileName = util.toboolean(param.isFileName)
  local isIgnoreCase = util.toboolean(param.isIgnoreCase)

  local files = {}

  if util.isNotEmpty(query) and util.isNotEmpty(directoryName) then
    local isPlainString = not isRegex

    aggregateAllFilesContainingQuery(files, directoryName, query, filter, isPlainString, isFileName, isIgnoreCase, {count = 0})
    util.doGarbageCollection({count = 0}, 0) -- do collectgarbage of anything left

    if util.isNotEmpty(replace) and #files > 0 then
      replaceQuery(files, directoryName, query, replace, isPlainString, isFileName, isIgnoreCase, param.repository, param.username, param.password)
    end
  end

  return parse(require("BaselineHtmlTemplate"), {
    title = util.escapePrintableChars(query), 
    externalJS = externalJS,
    externalCSS = externalCSS,
    initJS = parse(initJSTemplate, {
      title = util.escapePrintableChars(query), 
      files = json.encode(files)
    })
  })
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end