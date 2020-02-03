----------------
-- nginx.conf --
----------------


local nginxConf = [[
http {

	lua_package_path '../?.lua;';

	lua_package_cpath 'luajit/lib/?.so;';

	lua_load_resty_core off;

	init_by_lua_block {
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


local file = assert(io.open("nginx.conf", "w"))
file:write(nginxConf)
file:close()



--------------------------
-- nginx.config.octopus --
--------------------------


local loadExtension = function (extensionsDir, extensionName)
	package.path = package.path .. ";" .. extensionsDir .. "/" .. extensionName .. "/src/?.lua"
end

local loadPath = function (path)
	package.path = package.path .. ";" .. path
end

local loadCPath = function (cpath)
	package.cpath = package.cpath .. ";" .. cpath
end


local octopusExtensionsDir = "../../extensions"


loadCPath("luajit/lib/?.so;")
loadExtension(octopusExtensionsDir, "core")
loadExtension(octopusExtensionsDir, "orm")


local lfs = require "lfs"
local builder = require "builder"
local eval = require "eval"


local siteConfig = eval.file(octopusExtensionsDir .. "/config.lua", {
	octopusExtensionsDir = lfs.currentdir() .. "/" .. octopusExtensionsDir,
	octopusHostDir = lfs.currentdir() .. "/" .. octopusExtensionsDir,
	})
siteConfig.nginxConfFileName = "nginx.config.octopus"
builder.build(siteConfig)