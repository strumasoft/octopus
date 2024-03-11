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

  var repositoryLog = new Widget.RepositoryLog()

  var repositoryTemplate = new Widget.RepositoryTemplate({
    diff: repositoryLog.html
  })

  $.ajax({
    async: false,
    url: window.location.href + "&log=true",
    success: function (content) {
      Widget.setHtmlToPage(repositoryTemplate.html)
      Widget.RepositoryLog.setContent(content)
    },
    error: Widget.errorHandler
  })
]]


local function process ()
  if util.isEmpty(param.repository) then exception("repository name like GIT/SVN is required") end
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local directoryName = param.directoryName

  if param.log then
    local limit
    if util.isNotEmpty(param.limit) then limit = param.limit end

    return repository.logHistory(username, password, directoryName, limit)
  else
    local paths = util.split(directoryName, "/")

    return parse(require("BaselineHtmlTemplate"), {
      title = paths[#paths], 
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