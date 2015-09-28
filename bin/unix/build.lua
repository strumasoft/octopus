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

local function loadedPackages ()
    local packages = {}
    for k,v in pairs(package.loaded) do packages[k] = k end
    return packages
end

local function unloadPackages (whitelistedPackages)
    for k,v in pairs(package.loaded) do
        if whitelistedPackages[k] == nil then
            package.loaded[k] = nil
        end
    end
end


-- nginx.conf --

local nginxConf = [[
http {
		
	lua_package_path '../?.lua;';
  
	lua_package_cpath 'luajit/lib/?.so;';
	
	init_by_lua 'require = require "autowire"';
	
	types {
        text/html html;	    
        text/css css;
        application/javascript js;	    
        image/png png;
        image/gif gif;	    
        image/jpeg jpeg;
        image/jpg jpg;    
        image/x-icon ico;
    }
	
	# Regular servers
	include nginx.config.*;
	
} # end of http

events { 
    worker_connections 1024;
} # end of events

worker_processes 2;
]]


-- set up build names --

local octopus = {
    port = 7878,
    sslPort = 37878,
    process = {
        extensions = {"../../extensions", "/config_unix.lua"},
    }
}

-- arg[1] is the name of the build
if arg[1] then
    print("[" .. arg[1] .. "]")
    if arg[1] == "octopus" then 
        config = octopus
    else 
        error(arg[1] .. " is not name of build")
    end
else
    config = octopus
end


-- remove old configurations and create nginx.conf--

local whitelistedPackages = loadedPackages()
local originalPackagePath = package.path
local originalPackageCPath = package.cpath

loadCPath("luajit/lib/?.so;")
loadExtension("../../extensions", "core")

local lfs = require "lfs"
local dir = "."
for entry in lfs.dir(dir) do
    if entry ~= "." and entry ~= ".." then
        local path
		if dir ~= "/" then 
			path = dir .. "/" .. entry
		else
			path = "/" .. entry
		end
		
		local attr = lfs.attributes(path)
		if attr and attr.mode == "file" then
		    if path:find("nginx.config.", 1, true) then os.remove(path) end
	    end
    end
end

local parse = require "parse"
local file = assert(io.open("nginx.conf", "w"))
file:write(parse(nginxConf, config))
file:close()

unloadPackages(whitelistedPackages)
package.path = originalPackagePath
package.cpath = originalPackageCPath


-- create new configurations --

for k,v in pairs(config.process) do
    extensionsDir = v[1]
    local configFileName = v[2]
    
    local whitelistedPackages = loadedPackages()
    local originalPackagePath = package.path
    local originalPackageCPath = package.cpath
    
    loadCPath("luajit/lib/?.so;")
    loadExtension(extensionsDir, "core")
    loadExtension(extensionsDir, "orm")
    
    local function build ()
        print("build server from " .. extensionsDir .. configFileName)
        
        nginxConfFileName = "nginx.config." .. k
        
        dofile(extensionsDir .. configFileName)
        
        local builder = require "builder"
        builder.build()
    end
    local status, err = pcall(build)
    if not status then print(err) end
    
    unloadPackages(whitelistedPackages)
    package.path = originalPackagePath
    package.cpath = originalPackageCPath
end