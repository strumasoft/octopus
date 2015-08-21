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

hosts = {
    extensions = {"../../extensions", "/config_unix.lua"},
}

for k,v in pairs(hosts) do
    extensionsDir = v[1]
    local configFileName = v[2]
    
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
        package.loaded["builder"] = nil
    end
    local status, err = pcall(build)
    if not status then print(err) end
    
    package.path = originalPackagePath
    package.cpath = originalPackageCPath
end