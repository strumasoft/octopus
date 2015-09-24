local lfs = require "lfs"
local param = require "param"
local exception = require "exception"



local function noBackDirectory (path)
    if path:find("..", 1, true) then exception("no back directory allowed") end
end


local function countBackDirectories (path)
    local uris = param.split(path, "/")
        
    if uris[#uris] == ".." or uris[#uris] == "." or uris[#uris] == "" then
        exception("invalid path")
    end
    
    local back, entry = 0, 0
    for i=1, #uris-1 do
        if uris[i] == ".." then
            back = back + 1
            if uris[i+1] ~= ".." then -- end of pair
                if entry < back then
                    exception("invalid path")
                else
                    back, entry = 0, 0
                end
            end
        elseif uris[i] ~= "." and uris[i] ~= "" then
            entry = entry + 1
        end
    end
end


local function remove (file)
    local attr, err = lfs.attributes(file)
    if not attr then return end -- cannot obtain information from file / file does not exist
    
    if attr.mode == "directory" then
        local dir = file
        for entry in lfs.dir(dir) do
            if entry ~= "." and entry ~= ".." then
                local path
    			if dir ~= "/" then 
    				path = dir .. "/" .. entry
    			else
    				path = "/" .. entry
    			end
    			
    			local attr = lfs.attributes(path)
    			if attr.mode == "directory" then
    			    remove(path)
    			else
        		    local ok, err = os.remove(path)
                    if not ok then
                        exception(err)
                    end
                end
            end
        end
    
        local ok, err = os.remove(dir)
        if not ok then
            exception(err)
        end
    else
        local ok, err = os.remove(file)
        if not ok then
            exception(err)
        end
    end
end


local function createDirectory (path)
    local ok, err = lfs.mkdir(path)
    if not ok then
        exception(err)
    end
end


local function quoteCommandlineArgument (str)
    if str then
        return [[']] .. str:replace([[']], [['\'']], true) .. [[']]
    else
        return ""
    end
end


local specialCharacters = {
    [[\]], -- must be first
    [[`]], [[~]], [[!]], [[@]], [[#]], [[$]], [[%]], [[^]], [[&]], [[*]], [[(]], [[)]],
    [=[]]=], [=[[]=], [[{]], [[}]], 
    [[:]], [[;]], [["]], [[']], [[|]], 
    [[>]], [[<]], [[.]], [[,]], [[?]], [[/]],
    [[ ]], -- space must be last
}
        

local function escapeCommandlineSpecialCharacters (str)
    if str then
        for i=1,#specialCharacters do
            str = str:replace(specialCharacters[i], "\\" .. specialCharacters[i], true)
        end
        return str
    else
        return ""
    end
end


local function noCommandlineSpecialCharacters (str)
    if str then
        for i=1,#specialCharacters do
            if str:find(specialCharacters[i], 1, true) then 
                exception("no command line special characters")
            end
        end
    end
end


return {
    noBackDirectory = noBackDirectory,
    countBackDirectories = countBackDirectories,
    
    remove = remove,
    removeFile = remove,
    removeDirectory = remove,
    createDirectory = createDirectory,
    
    quoteCommandlineArgument = quoteCommandlineArgument,
    escapeCommandlineSpecialCharacters = escapeCommandlineSpecialCharacters,
    noCommandlineSpecialCharacters = noCommandlineSpecialCharacters,
}