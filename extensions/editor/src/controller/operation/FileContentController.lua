local param = require "param"
local exit = require "exit"
local util = require "util"
local editor = require "Editor"



local notPlainTextExtensions = [[
 flac mp3 ogg oga mogg raw voc vox wav wma wv webm 
 3gp 3g2 flv f4v f4p f4a f4b ogv gif gifv avi mp4 m4p m4v mpg mp2 mpeg mpe mpv mts m2ts mov qt wmv yuv 
 jpg jpeg jpe jif jfif jfi png webp tiff tif psd raw arw cr2 nrw k25 bmp dib heif heic ind indd indt jp2 j2k jpf jpx jpm mj2 ico svgz ai eps 
 pdf doc docx dot odt ott xls xlsx ppt pptx 
 exe dll so o a ar cpio shar lbr iso mar sbx f xf lz lzma lzmo rz sfark sz q z xz 
 7z s7z ace afa alz apk arc ark cdx b1 cab dmg jar rar gz tgz tbz2 tar bz2 txz war zip zipx zz 
]]

ngx.header.content_type = 'text/plain'


local function process ()
  local fileName = param.f

  local paths = util.split(fileName, "/")
  local name = paths[#paths]

  local extensions, hasExtension = util.split(name, ".")
  local extension = extensions[#extensions]

  if hasExtension and notPlainTextExtensions:findQuery(" " .. extension .. " ", 1, true, true) then
    return "File is not plain text!"
  else
    return editor.fileContent(fileName)
  end
end


local status, res = pcall(process)
if status then
  if res then ngx.say(res) end
else
  exit(res)
end
