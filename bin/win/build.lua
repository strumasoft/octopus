-- build --
-- 		lua52.exe build.lua

-- run --
--		nginx.exe -c nginx.conf



-- load --

local loadExtension = function (extensionsDir, extensionName)
	package.path = package.path .. ";" .. extensionsDir .. "/" .. extensionName .. "/src/?.lua"
end

local loadPath = function (path)
	package.path = package.path .. ";" .. path
end

local loadCPath = function (cpath)
	package.cpath = package.cpath .. ";" .. cpath
end


-- build --

workerProcesses = 1
workerConnections = 1024
externalPaths = ""
externalCPaths = "clibs/?.dll;"


extensionsDir = "../../extensions"
local configFileName = "/config_win.lua"

local originalPackagePath = package.path
local originalPackageCPath = package.cpath

loadCPath(externalCPaths)
loadExtension(extensionsDir, "core")
loadExtension(extensionsDir, "orm")

local function build ()
	print("build server from " .. extensionsDir .. configFileName)

	dofile(extensionsDir .. configFileName)

	local builder = require "builder"
	builder.build()
end
local status, err = pcall(build)
if not status then print(err) end

package.path = originalPackagePath
package.cpath = originalPackageCPath