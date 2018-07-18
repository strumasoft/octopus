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
local lfs = require "lfs"
octopusSitesDir = lfs.currentdir() .. "/../../sites"
loadExtension(octopusSitesDir .. "/common/", "core")
loadExtension(octopusSitesDir .. "/common/", "orm")
local eval = require "eval"


local builder = require "builder"


local octopusSitesConfig = eval.file(octopusSitesDir .. "/config.lua", {})
local octopusSites = octopusSitesConfig.sites;

----------------
-- nginx.conf --
----------------


local nginxConf = [[
http {

	lua_package_path '../?.lua;';

	lua_package_cpath 'lualib/lib/lua/5.1/?.so;luajit/lib/?.so;';

	init_by_lua 'require "cdefinitions"; require = require "autowire"';

	# mime types
	include mime.types;

	# applications
	include conf.d/*.conf;

} # end of http

events { 
	worker_connections  4096;
	multi_accept        on;
	use                 epoll;
} # end of events

worker_processes auto;
]]


local file = assert(io.open("nginx.conf", "w"))
file:write(nginxConf)
file:close()



--------------------------
-- nginx.config.octopus --
--------------------------





for i=1,#octopusSites do


	local octopusExtensionsDir = "../../sites/" .. octopusSites[i]

	local siteConfig = eval.file(octopusExtensionsDir .. "/config.lua", {
		octopusExtensionsDir = lfs.currentdir() .. "/" .. octopusExtensionsDir,
		octopusHostDir = lfs.currentdir() .. "/" .. octopusExtensionsDir,
		})
	siteConfig.nginxConfFileName = lfs.currentdir()  .. "/conf.d/" .. octopusSites[i] .. ".conf"
	builder.build(siteConfig)
end	