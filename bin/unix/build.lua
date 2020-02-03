---------------------------
-- set up build profiles --
---------------------------


local octopusExtensionsDir = "../../extensions"

-- add project in the following relative form:
-- key = {"../../../dir", "config.lua"}
local hosts = {
	extensions = {octopusExtensionsDir, "config.lua"},
}

local hostNames = {}
for k, v in pairs(hosts) do	table.insert(hostNames, k) end

local profiles = {}
profiles.prod = {
	profile = "prod", hosts = hostNames,
	port = 8787, securePort = 38787, luaCodeCache = "on",
	requireSecurity = false, sessionTimeout = 14400,
	rdbms = "mysql", rdbms_host = "127.0.0.1", rdbms_port = "3306", rdbms_user = "demo", rdbms_password = "demo",
}
profiles.test = {
	profile = "test", hosts = hostNames,
	port = 8787, securePort = 38787, luaCodeCache = "off",
	requireSecurity = false, sessionTimeout = 3600,
	rdbms = "mysql", rdbms_host = "127.0.0.1", rdbms_port = "3306", rdbms_user = "demo", rdbms_password = "demo",
}

local buildProfile = arg[1]
if buildProfile then
	print("[" .. buildProfile .. "]")
	if profiles[buildProfile] then 
		config = profiles[buildProfile]
	else
		error(buildProfile .. " is not name of build profile")
	end
else
	config = profiles["test"]
end



----------------
-- nginx.conf --
----------------


local nginxConf = [[
http {

	lua_package_path '../?.lua;lib/?.lua;;';

	lua_package_cpath 'luajit/lib/?.so;;';

	init_by_lua_block {
		require "resty.core"
		collectgarbage("collect")
		require "cdefinitions"
		require = require "autowire"
	}

	# mime types
	include mime.types;

	# applications
	include nginx.config.*;

} # end of http

events { 
	worker_connections  4096;
	multi_accept        on;
	use                 epoll;
} # end of events

worker_processes auto;
]]



--------------------
-- nginx.config.* --
--------------------


-- load functions --

local loadExtension = function (extensionsDir, extensionName)
	package.path = package.path .. ";" .. extensionsDir .. "/" .. extensionName .. "/src/?.lua"
end

local loadPath = function (path)
	package.path = package.path .. ";" .. path
end

local loadCPath = function (cpath)
	package.cpath = package.cpath .. ";" .. cpath
end

loadCPath("luajit/lib/?.so;")
loadExtension(octopusExtensionsDir, "core")
loadExtension(octopusExtensionsDir, "orm")


-- remove old configurations --

local lfs = require "lfs"
local dir = "."
for entry in lfs.dir(dir) do
	if entry ~= "." and entry ~= ".." then
		local path
		if dir ~= "/" then path = dir .. "/" .. entry else path = "/" .. entry end

		local attr = lfs.attributes(path)
		if attr and attr.mode == "file" then
			if path:find("nginx.config.", 1, true) then os.remove(path) end
		end
	end
end


-- create nginx.conf --

local parse = require "parse"
local file = assert(io.open("nginx.conf", "w"))
file:write(parse(nginxConf, config))
file:close()


-- create new configurations --

local builder = require "builder"
local eval = require "eval"
for i=1,#config.hosts do
	local hostDirName = config.hosts[i]
	local extensionsDir = hosts[hostDirName][1]
	local configFileName = hosts[hostDirName][2]

	local function build ()
		print("build server from " .. extensionsDir .. "/" .. configFileName)
		
		-- override site configFileName (config.lua) with the profile configurations
		config.octopusExtensionsDir = lfs.currentdir() .. "/" .. octopusExtensionsDir
		config.octopusHostDir = lfs.currentdir() .. "/" .. extensionsDir
		local siteConfig = eval.file(extensionsDir .. "/" .. configFileName, config)
		siteConfig.nginxConfFileName = "nginx.config." .. hostDirName
		
		builder.build(siteConfig)
	end
	local status, err = pcall(build)
	if not status then print(err) end
end