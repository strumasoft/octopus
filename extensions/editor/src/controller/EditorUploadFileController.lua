local json = require "json"
local param = require "param"
local parse = require "parse"
local upload = require "upload"
local exit = require "exit"
local exception = require "exception"
local util = require "util"
local fileutil = require "fileutil"
local property = require "property"
local sourceCtxPath = property.sourceCtxPath or ""


local externalCSS = [[
  <link href="/editor/static/search-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
]]


local initJSTemplate = [[
  var vars = {}

  var uploadResult = new Widget.UploadResult({{files}})

  var editorSearchTemplate = new Widget.EditorSearchTemplate({
    searchResult: uploadResult.html
  })

  Widget.setHtmlToPage(editorSearchTemplate.html);
]]


local function getFileName (res)
  if res and res[1] and res[1] == "Content-Disposition" and res[2] then
    local x, y = res[2]:indexOf('filename=', 1)
    if x and y then
      local simpleFileName = res[2]:sub(y+2, #res[2]-1)
      
      fileutil.noBackDirectory(simpleFileName)
      
      return simpleFileName
    end
    
    exception("file name parameter not found")
  end
end


local function uploadFiles (directoryName)
  local file, files = nil, {}
  
  local form, err = upload:new(property.fileUploadChunkSize)
  if err then exception(err) end
  
  while true do
    local typ, res, err = form:read()
    
    if not typ then
      exception("failed to read: " .. err)
    end
    
    if typ == "header" then
      local simpleFileName = getFileName(res)
      if not file and simpleFileName then
        local fileName = directoryName .. "/" .. simpleFileName
        file = io.open(sourceCtxPath .. fileName, "w+")
        if not file then
          exception("failed to open file " .. fileName)
        else
          files[#files+1] = simpleFileName
        end
      end
    elseif typ == "body" then
      if file then
        file:write(res)
      end
    elseif typ == "part_end" then
      file:close()
      file = nil
    elseif typ == "eof" then
      return files
    else
      -- do nothing
    end
  end
end


local function process ()
  local directoryName = param.directoryName
  if util.isNotEmpty(directoryName) then
    fileutil.noBackDirectory(directoryName)
    
    local files = uploadFiles(directoryName)
  
    return parse(require("BaselineHtmlTemplate"), {
      title = "Upload",
      externalCSS = externalCSS,
      initJS = parse(initJSTemplate, {
        files = json.encode(files)
      })
    })
  else
    exception("directoryName is empty")
  end
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end