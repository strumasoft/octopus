local json = require "json"
local parse = require "parse"
local param = require "param"
local exit = require "exit"
local exception = require "exception"
local util = require "util"



local externalJS = [[
  <script type="text/javascript" src="/baseline/static/js/init-baseline.js"></script>

  <link rel="stylesheet" type="text/css" href="/baseline/static/js/diffview.css"/>
]]


local externalCSS = [[
  <link href="/repository/static/repository-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
]]


local initJSTemplate = [[
  var vars = {}

  var repositoryPatch = new Widget.RepositoryPatch()

  var repositoryTemplate = new Widget.RepositoryTemplate({
    diff: repositoryPatch.html
  })

  $.ajax({
    async: false,
    dataType: "json",
    url: window.location.href + "&patch=true",
    success: function (content) {
      Widget.setHtmlToPage(repositoryTemplate.html)
      Widget.RepositoryPatch.setContent(content)
    },
    error: Widget.errorHandler
  })
]]

local function splitPatch (text, delimiter)
  local substrings = {}

  local iteratorIndex = 0
  repeat
    local startDelimiterIndex = text:indexOf(delimiter, iteratorIndex)
    if startDelimiterIndex then
      if iteratorIndex ~= startDelimiterIndex - 1 then
        if iteratorIndex > 0 then
          substrings[#substrings + 1] = text:sub(iteratorIndex - delimiter:len(), startDelimiterIndex - 1)
        else
          substrings[#substrings + 1] = text:sub(iteratorIndex, startDelimiterIndex - 1)
        end
      end

      iteratorIndex = startDelimiterIndex + delimiter:len()
    else
      if iteratorIndex > 0 then
        substrings[#substrings + 1] = text:sub(iteratorIndex - delimiter:len(), text:len())
      else
        substrings[#substrings + 1] = text:sub(iteratorIndex, text:len())
      end
    end  
  until startDelimiterIndex == nil

  return substrings
end


local function process ()
  if util.isEmpty(param.repository) then exception("repository name like GIT/SVN is required") end
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local directoryName = param.directoryName
  local newRevision = param.newRevision
  local oldRevision = param.oldRevision

  if param.patch then
    local patch, delimiter = repository.commitHistory(username, password, directoryName, newRevision, oldRevision)
    return json.encode(splitPatch(patch, delimiter))
  else
    local title
    if util.isNotEmpty(oldRevision) then
      title = oldRevision .. ":" .. newRevision
    else
      title = newRevision
    end

    return parse(require("BaselineHtmlTemplate"), {
      title = title, 
      customCSS = [[
      #skel-layers-wrapper {padding-top: 0;}
      ]],
      externalJS = externalJS,
      externalCSS = externalCSS,
      initJS = parse(initJSTemplate, json.encodeProperties({}))
    })
  end
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end