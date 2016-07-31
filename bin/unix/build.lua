----------------
-- nginx.conf --
----------------


local nginxConf = [[
http {

	lua_package_path '../?.lua;';

	lua_package_cpath 'luajit/lib/?.so;';

	init_by_lua 'require "cdefinitions"; require = require "autowire"';

	types {
		text/html html;	    
		text/css css;
		application/javascript js;	    
		image/png png;
		image/gif gif;	    
		image/jpeg jpeg;
		image/jpg jpg;    
		image/x-icon ico;
		application/pdf pdf;
	}

	# Regular servers
	include nginx.config.*;

} # end of http

events { 
	worker_connections 1024;
} # end of events

worker_processes 2;
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