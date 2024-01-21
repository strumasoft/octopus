local json = require "json"
local parse = require "parse"
local param = require "param"
local exit = require "exit"
local util = require "util"



local externalJS = [[
  <script type="text/javascript" src="/baseline/static/js/init-baseline.js"></script>
  <script src="/baseline/static/js/diff_match_patch.js" type="text/javascript"></script>
  <script src="/baseline/static/js/jquery.pretty-text-diff.js" type="text/javascript"></script>

  <link rel="stylesheet" type="text/css" href="/baseline/static/js/diffview.css"/>
  <script type="text/javascript" src="/baseline/static/js/diffview.js"></script>
  <script type="text/javascript" src="/baseline/static/js/difflib.js"></script>
]]


local externalCSS = [[
  <link href="/repository/static/repository-favicon.ico" rel="shortcut icon" type="image/vnd.microsoft.icon" />
]]


local customJS = [[
  function diffUsingJS(viewType, originalContent, changedContent) {
    "use strict";
    var byId = function (id) { return document.getElementById(id); },
      base = difflib.stringAsLines(originalContent),
      newtxt = difflib.stringAsLines(changedContent),
      sm = new difflib.SequenceMatcher(base, newtxt),
      opcodes = sm.get_opcodes(),
      diffoutputdiv = byId("diffoutput");

    diffoutputdiv.innerHTML = "";
    var contextSize = null;

    diffoutputdiv.appendChild(diffview.buildView({
      baseTextLines: base,
      newTextLines: newtxt,
      opcodes: opcodes,
      baseTextName: "OLD",
      newTextName: "NEW",
      contextSize: contextSize,
      viewType: viewType
    }));
  }
]]


local initJSTemplate = [[
  var vars = {}

  var repositoryDiff = new Widget.RepositoryDiff({})
  var repositoryStatusNavigation = new Widget.RepositoryStatusNavigation({{statuses}})
  var repositoryStatusHeader = new Widget.RepositoryStatusHeader({{title}})

  var repositoryTemplate = new Widget.RepositoryTemplate({
    navigation: repositoryStatusNavigation.html, 
    header: repositoryStatusHeader.html,
    diff: repositoryDiff.html
  })

  Widget.setHtmlToPage(repositoryTemplate.html)
]]


local function process ()
  local repository = require(param.repository)

  local username = param.username
  local password = param.password
  local directoryName = param.directoryName

  local paths = util.split(directoryName, "/")
  local title = paths[#paths]

  return parse(require("BaselineHtmlTemplate"), {
    title = title, 
    externalJS = externalJS,
    externalCSS = externalCSS,
    customJS = customJS,
    initJS = parse(initJSTemplate, json.encodeProperties({
      statuses = repository.status(username, password, directoryName),
      title = directoryName
    }))
  })
end


local ok, res = pcall(process)
if ok then
  if res then ngx.say(res) end
else
  exit(res)
end