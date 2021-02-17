local common = require("db.api.common")
local uuid = require "uuid"
local exception = require "exception"
local util = require "util"


--
-- forward declaration of functions
--
local connectToDatabase
local getReferences
local prePopulate
local query


--
-- number of properties of object
--
local length = common.length


--
-- UTILS
--

local function createRelation (from, to)
	local typeTo = util.split(to, ".")[1]
	local typeFrom = util.split(from, ".")[1]

	if from < to then
		return {type = from .. "-" .. to}, true, typeTo == typeFrom
	else
		return {type = to .. "-" .. from}, false, typeTo == typeFrom
	end
end


local function checkIfToIsOne (types, d, p, from, to)
	if to:find(".", 1, true) then
		local typeAndProperty = util.split(to, ".")
		local referenceType = typeAndProperty[1]
		local referenceProperty = typeAndProperty[2]

		local property = types[referenceType][referenceProperty]
		if property.has == "one" then
			if #p == 0 then p = {p} end    

			for i=1,#p do
				local relation, straight, selfReferencing = createRelation(from, to)
				if straight then
					if selfReferencing then
						relation.key = p[i].id
					else
						relation.value = p[i].id
					end
				else
					if selfReferencing then
						relation.value = p[i].id
					else
						relation.key = p[i].id
					end
				end
				d[#d + 1] = relation
			end
		end
	end
end


local function createRelations (types, update, d, o, id, p, index, from, to)
	if index == 0 then
		if update then
			local relation, straight, selfReferencing = createRelation(from, to)
			if straight then
				if selfReferencing then
					relation.value = id
				else
					relation.key = id
				end
			else
				if selfReferencing then
					relation.key = id
				else
					relation.value = id
				end
			end
			d[#d + 1] = relation
		end

		checkIfToIsOne(types, d, p, from, to)
	end

	if type(p) == "table" then
		local relation, straight, selfReferencing = createRelation(from, to)

		local relationName = relation.type
		relation.type = nil -- delete relation name

		if #p == 0 then
			if not p.id then exception(from .. "[" .. index .. "] does not have id or it is not persisted") end
			if straight then
				if selfReferencing then
					relation.key = p.id
					relation.value = id
				else
					relation.key = id
					relation.value = p.id
				end
			else
				if selfReferencing then
					relation.key = id
					relation.value = p.id
				else
					relation.key = p.id
					relation.value = id
				end
			end

			-- do not add if key/value is empty/null --> set list to empty
			if util.isNotEmpty(relation.key) and util.isNotEmpty(relation.value) then
				if o[relationName] then
					o[relationName][#o[relationName] + 1] = {uuid(), relation.key, relation.value}
				else
					o[relationName] = {{uuid(), relation.key, relation.value}}
				end
			end
		else
			for i=1,#p do 
				createRelations(types, update, d, o, id, p[i], i, from, to)
			end
		end
	else
		local relation, straight, selfReferencing = createRelation(from, to)

		local relationName = relation.type
		relation.type = nil -- delete relation name

		if straight then
			if selfReferencing then
				relation.key = p
				relation.value = id
			else
				relation.key = id
				relation.value = p
			end
		else
			if selfReferencing then
				relation.key = id
				relation.value = p
			else
				relation.key = p
				relation.value = id
			end
		end

		-- do not add if key/value is empty/null --> set list to empty
		if util.isNotEmpty(relation.key) and util.isNotEmpty(relation.value) then
			if o[relationName] then
				o[relationName][#o[relationName] + 1] = {uuid(), relation.key, relation.value}
			else
				o[relationName] = {{uuid(), relation.key, relation.value}}
			end
		end
	end
end


local function splitValueToPropertiesAndReferences (config, types, update, typeName, value, id)
	local t = types[typeName] -- type
	if t then
		local r = {} -- rows/properties
		local o = {} -- objects/references/relations
		local d = {} -- delete

		for k,v in pairs(value) do
			local property = t[k]
			if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

			if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
				r[k] = v
			else
				local from = typeName .. "." .. k
				local to = property.type

				createRelations(types, update, d, o, id or value.id, v, 0, from, to)

				-- check if property has one reference or many
				local relation, straight, selfReferencing = createRelation(from, to)
				if property.has == "one" and #o[relation.type] > 1 then
					exception(from .. " must be one not many")
				end
			end
		end

		return r, o, d
	else
		exception("type " .. typeName .. " does not exist!")
	end
end


local function addRelations (self, o)
	for k,v in pairs(o) do
		local sql = common.addBulk(self.tableConfig, k, {"id", "key", "value"}, v)
		query(self, sql)
	end
end


local function updateRelations (self, d, o)
	-- first remove old relations
	for i=1,#d do
		local relationType = d[i].type
		d[i].type = nil

		local sql = common.delete(self.tableConfig, relationType, d[i])
		query(self, sql)
	end

	-- then add new relations
	addRelations(self, o)
end


local function createAlias (aliases, typeName)
	local alias = aliases[typeName]
	if alias then
		alias = "_" .. alias
	else
		alias = typeName
	end
	aliases[typeName] = alias

	return alias
end


local function splitValueToJoinAndWhere (types, typeName, value, join, where, aliases)
	local t = types[typeName] -- type
	if t then
		for k,v in pairs(value) do
			local property = t[k]
			if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

			if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
				if aliases[typeName] then -- self referencing
					where[#where + 1] = {type = aliases[typeName], property = k, operation = v}
				else
					where[#where + 1] = {type = typeName, property = k, operation = v}
				end
			else
				local from = typeName .. "." .. k
				local to = property.type

				local referenceType
				if property.type:find(".", 1, true) then
					local typeAndProperty = util.split(property.type, ".")
					referenceType = typeAndProperty[1]
				else
					referenceType = property.type
				end

				local typeNameAlias = aliases[typeName]

				if referenceType == typeName then -- self referencing
					if from < to then
						local relationType = from .. "-" .. to

						local relationTypeAlias = createAlias(aliases, relationType)

						join[#join + 1] = {
							type = relationType,
							alias = relationTypeAlias,
							from = {type = typeNameAlias, property = "id"}, 
							to = {type = relationTypeAlias, property = "value"}
						}

						local referenceTypeAlias = createAlias(aliases, referenceType)

						join[#join + 1] = {
							type = referenceType,
							alias = referenceTypeAlias,
							from = {type = relationTypeAlias, property = "key"}, 
							to = {type = referenceTypeAlias, property = "id"}
						}
					else
						local relationType = to .. "-" .. from

						local relationTypeAlias = createAlias(aliases, relationType)

						join[#join + 1] = {
							type = relationType,
							alias = relationTypeAlias,
							from = {type = typeNameAlias, property = "id"}, 
							to = {type = relationTypeAlias, property = "key"}
						}

						local referenceTypeAlias = createAlias(aliases, referenceType)

						join[#join + 1] = {
							type = referenceType,
							alias = referenceTypeAlias,
							from = {type = relationTypeAlias, property = "value"}, 
							to = {type = referenceTypeAlias, property = "id"}
						}
					end
				else
					if from < to then
						local relationType = from .. "-" .. to

						local relationTypeAlias = createAlias(aliases, relationType)

						join[#join + 1] = {
							type = relationType,
							alias = relationTypeAlias,
							from = {type = typeNameAlias, property = "id"}, 
							to = {type = relationTypeAlias, property = "key"}
						}

						local referenceTypeAlias = createAlias(aliases, referenceType)

						join[#join + 1] = {
							type = referenceType,
							alias = referenceTypeAlias,
							from = {type = relationTypeAlias, property = "value"}, 
							to = {type = referenceTypeAlias, property = "id"}
						}
					else
						local relationType = to .. "-" .. from

						local relationTypeAlias = createAlias(aliases, relationType)

						join[#join + 1] = {
							type = relationType,
							alias = relationTypeAlias,
							from = {type = typeNameAlias, property = "id"}, 
							to = {type = relationTypeAlias, property = "value"}
						}

						local referenceTypeAlias = createAlias(aliases, referenceType)

						join[#join + 1] = {
							type = referenceType,
							alias = referenceTypeAlias,
							from = {type = relationTypeAlias, property = "key"}, 
							to = {type = referenceTypeAlias, property = "id"}
						}
					end
				end

				splitValueToJoinAndWhere(types, referenceType, v, join, where, aliases)
			end
		end
	else
		exception("type " .. typeName .. " does not exist!")
	end
end


local function getProperties (types, typeName)
	local what = {}

	local t = types[typeName] -- type
	for key,property in pairs(t) do
		if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
			what[#what + 1] = key
		end
	end

	return what
end


local function callMetamethod (collection, argument) -- t == collection
	if argument then
		if #argument > 0 then -- argument is array, so it is references
			local references = argument
			prePopulate(collection, references)
			return collection
		else -- argument is object, so it is filter
			local filter = argument

			if #collection > 0 then
				local res = {}
				for i=1,#collection do
					local success = true
					for k,v in pairs(filter) do
						if success and collection[i][k] ~= v then success = false end
					end
					if success then res[#res + 1] = collection[i] end
				end
				return res
			else
				local object = collection

				local success = true
				for k,v in pairs(filter) do
					if success and object[k] ~= v then success = false end
				end
				if success then return object end
			end
		end
	end
end


local function getMetatableWithReferences (self, referenceType)
	local mt = {
		__index = function (obj, propertyName)
			-- collection (non empty), object or null
			local collection = getReferences(self, referenceType, propertyName, obj.id)

			if collection and #collection > 0 then -- collection is collection (non empty), not object or null
				setmetatable(collection, {__call = callMetamethod})
			end

			obj[propertyName] = collection
			return collection
		end,

		__call = callMetamethod,
	}

	return mt
end


--
-- return result as collection (non empty), object or null
-- if 'from' is nil then db:find was executed and __call is added to each res[i]
--
local function setUpReferences (self, referenceType, res, one, from)
	if #res > 0 then
		if one then
			if #res > 1 then
				local json = require "json"
				ngx.log(ngx.ERR, from .." must be one not many ==> " .. json.encode(res)) -- DEBUG
			end

			local obj = res[1]
			local mt = getMetatableWithReferences(self, referenceType)
			setmetatable(obj, mt)
			return obj
		else
			for i=1,#res do
				local mt = getMetatableWithReferences(self, referenceType)
				setmetatable(res[i], mt)
			end
			return res
		end
	end
end


--
-- return result as collection (non empty), object or null
--
getReferences = function (self, typeName, k, id)
	local t = self.types[typeName] -- type
	if t then
		local property = t[k]

		if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

		if property.type == "id" or property.type == "integer" or property.type == "float" or property.type == "boolean" or property.type == "string" then
			return nil -- empty value
		else
			local from = typeName .. "." .. k
			local to = property.type

			local referenceType
			if property.type:find(".", 1, true) then
				local typeAndProperty = util.split(property.type, ".")
				referenceType = typeAndProperty[1]
			else
				referenceType = property.type
			end

			local join = {}
			local alias = "_" .. typeName
			if referenceType == typeName then -- self referencing
				if from < to then
					local relationType = from .. "-" .. to
					join[#join + 1] = {
						type = relationType, 
						from = {type = referenceType, property = "id"}, 
						to = {type = relationType, property = "key"}
					}
					join[#join + 1] = {
						type = typeName,
						alias = alias,
						from = {type = relationType, property = "value"}, 
						to = {type = alias, property = "id"}
					}
				else
					local relationType = to .. "-" .. from
					join[#join + 1] = {
						type = relationType,
						from = {type = referenceType, property = "id"}, 
						to = {type = relationType, property = "value"}
					}
					join[#join + 1] = {
						type = typeName,
						alias = alias,
						from = {type = relationType, property = "key"}, 
						to = {type = alias, property = "id"}
					}
				end
			else
				if from < to then
					local relationType = from .. "-" .. to
					join[#join + 1] = {
						type = relationType, 
						from = {type = referenceType, property = "id"}, 
						to = {type = relationType, property = "value"}
					}
					join[#join + 1] = {
						type = typeName,
						from = {type = relationType, property = "key"}, 
						to = {type = typeName, property = "id"}
					}
				else
					local relationType = to .. "-" .. from
					join[#join + 1] = {
						type = relationType,
						from = {type = referenceType, property = "id"}, 
						to = {type = relationType, property = "key"}
					}
					join[#join + 1] = {
						type = typeName,
						from = {type = relationType, property = "value"}, 
						to = {type = typeName, property = "id"}
					}
				end
			end


			-- find references --

			local what = getProperties(self.types, referenceType)

			local where = {}
			if referenceType == typeName then -- self referencing
				where[#where + 1] = {type = alias, property = "id", operation = {operator = self.tableConfig.operators.equal, value = id}}
			else
				where[#where + 1] = {type = typeName, property = "id", operation = {operator = self.tableConfig.operators.equal, value = id}}
			end

			local sql = common.select(self.tableConfig, referenceType, what, join, where, false, nil, nil)
			local res = query(self, sql)

			return setUpReferences(self, referenceType, res, property.has == "one", from)
		end
	else
		exception("type " .. typeName .. " does not exist!")
	end
end


prePopulate = function (res, references)
	-- res is collection (may be empty but may be not), object or null

	if not res then return end
	if length(res) == 0 then return end

	for i=1,#references do
		if type(references[i]) == "table" then
			if length(references[i]) ~= 1 then
				exception("filter only one field") 
			end

			for k,v in pairs(references[i]) do
				if #v == 0 then -- filter
					if #res > 0 then
						for j=1,#res do
							if res[j][k] then
								local x = res[j][k](v)
								res[j][k] = x
							end
						end
					else
						if res[k] then
							local x = res[k](v)
							res[k] = x
						end
					end
				else -- populate references of references
					if #res > 0 then
						for j=1,#res do
							local x = res[j][k]
							prePopulate(x, v)
						end
					else
						local x = res[k]
						prePopulate(x, v)
					end
				end
			end
		else -- populate references
			if #res > 0 then
				for j=1,#res do
					local x = res[j][references[i]]
				end
			else
				local x = res[references[i]]
			end
		end
	end
end


--
-- END OF UTILS
--



--
-- TRANSACTIONS
--


--
-- NOTE: ngx.ctx.activeTransaction guards nested transactions, initial false
--


--
-- begin transaction
--
local function beginTransaction (self)
	query(self, "BEGIN")
end


--
-- commit transaction
--
local function commitTransaction (self)
	query(self, "COMMIT")
end


--
-- rollback transaction
--
local function rollbackTransaction (self)
	query(self, "ROLLBACK", true)
end


--
-- transaction
--
local function transaction (self, f, ...)
	local lock = false
	if not ngx.ctx.activeTransaction then
		beginTransaction(self)

		ngx.ctx.activeTransaction = true
		lock = true
	end

	local status, res = pcall(f, self, ...)

	if not status then
		ngx.ctx.activeTransaction = false

		rollbackTransaction(self)

		self.db:close()
		self.db = connectToDatabase(self.connection)

		error(res)
	else
		if lock then
			ngx.ctx.activeTransaction = false

			commitTransaction(self) 
		end
		return res
	end
end


local function protectedTransaction (self, f, ...)
	if ngx.ctx.activeTransaction then
		ngx.ctx.activeTransaction = false

		rollbackTransaction(self)

		self.db:close()
		self.db = connectToDatabase(self.connection)

		exception("do not nest transaction inside transaction")
	else
		return transaction (self, f, ...)
	end
end


local function protected (self, f, ...)
	local status, res, res2, res3, res4, res5 = pcall(f, self, ...)
	if not status then
		self.db:close()
		self.db = connectToDatabase(self.connection)

		error(res)
	else
		return res, res2, res3, res4, res5
	end
end


--
-- END OF TRANSACTIONS
--



--
-- API
--


--
-- operators
--
local function operators (self)
	return common.operators(self.tableConfig.operators)
end


--
-- query
--
query = function (self, sql, doNotThrow)
	if self.debugDB then
		ngx.log(ngx.ERR, sql) -- DEBUG
	end

	local res, err = self.db:query(sql)

	while err == "again" and self.usePreparedStatement do
		res, err = self.db:read_result() -- we are looking for the last one
	end

	if err then
		if doNotThrow then
			if self.debugDB then
				ngx.log(ngx.ERR, "\tERROR: " .. err) -- DEBUG
			end
			return nil, err
		else
			exception(err)
		end
	else
		if #res > 0 then
			if self.debugDB then
				local json = require "json"
				ngx.log(ngx.ERR, "\tRESULT: " .. json.encode(res)) -- DEBUG
			end
		end
		return res
	end
end


--
-- close
--
local function close (self)
	local res, err = self.db:close()
	if err then exception(err) end
end


--
-- create table
--
local function createTable (self, typeName)
	local sql = common.createTable(self.tableConfig, self.types, typeName)
	query(self, sql)
end


--
-- create all tables
--
local function createAllTables (self)
	for k,v in pairs(self.types) do
		self:createTable(k)
	end
end


--
-- drop table
--
local function dropTable (self, typeName)
	local sql = common.dropTable(self.tableConfig, self.types, typeName)
	query(self, sql)
end


--
-- drop all tables
--
local function dropAllTables (self)
	local res = query(self, self.tableConfig.allTablesSQL(self.connection.database))

	for i=1,#res do
		self:dropTable(res[i].table_name or res[i].TABLE_NAME)
	end
end


--
-- updateAllTables
--
local function updateAllTables (self)

end


--
-- export
--
local function export (self)
	local persistence = require "persistence"
	local property = require "property"

	local objects = {}
	local relations = {}

	for k,v in pairs(self.types) do
		local res = self:find({[k] = {}})

		if #res > 0 then
			local t = {}

			for i=1,#res do
				local id = res[i].id
				res[i].id = nil

				t[id] = res[i]
			end

			if k:find("-", 1, true) then
				relations[k] = t
			else
				objects[k] = t
			end
		end
	end

	-- persist types --
	persistence.store(property.octopusHostDir .. "/import.lua", {objects = objects, relations = relations});
end


--
-- import
--
local function import (self, import)
	if type(import) == "string" then
		import = require(import)
	elseif type(import) == "table" then
		-- nothing more needed
	else
		exception("supply name of the module to import or the import object itself")
	end

	if import.objects then
		for typeName,typeMap in pairs(import.objects) do
			for _,obj in pairs(typeMap) do
				local id = self:add({[typeName] = obj})
				obj.id = id
			end
		end
	end

	if import.relations then
		for typeName,typeMap in pairs(import.relations) do
			local fromToRelation = util.split(typeName, "-")

			local from
			if fromToRelation[1]:find(".", 1, true) then
				from = util.split(fromToRelation[1], ".")[1] -- first part
			else
				from = fromToRelation[1]
			end

			local to
			if fromToRelation[2]:find(".", 1, true) then
				to = util.split(fromToRelation[2], ".")[1] -- first part
			else
				to = fromToRelation[2]
			end

			for _,obj in pairs(typeMap) do
				local key = import.objects[from][obj.key].id
				local value = import.objects[to][obj.value].id

				local id = self:add({[typeName] = {key = key, value = value}})
			end
		end
	end
end


--
-- select
--
local function select (self, proto, references, count, page, orderBy)
	if length(proto) ~= 1 then
		exception("find only one type") 
	end

	for typeName,v in pairs(proto) do
		local join = {}
		local where = {}
		local aliases = {}
		aliases[typeName] = typeName

		splitValueToJoinAndWhere(self.types, typeName, v, join, where, aliases)

		local what = getProperties(self.types, typeName)

		local sql = common.select(self.tableConfig, typeName, what, join, where, count, page, orderBy)
		local res = query(self, sql)

		local resWithReferences = setUpReferences(self, typeName, res, false)

		if references then
			prePopulate(resWithReferences, references)
		end

		if resWithReferences then
			return resWithReferences, typeName
		else
			return res, typeName
		end
	end
end


--
-- add
--
local function add (self, proto)
	if length(proto) ~= 1 then
		exception("add only one type") 
	end

	for k,v in pairs(proto) do
		v.id = uuid()

		local r, o, d = splitValueToPropertiesAndReferences(self.tableConfig, self.types, false, k, v)

		-- 'r' contains at least id
		local sql = common.add(self.tableConfig, k, r)
		query(self, sql)

		updateRelations(self, d, o)

		local mt = getMetatableWithReferences(self, k)
		setmetatable(v, mt)

		return v.id
	end
end


--
-- add all
--
local function addAll (self, proto, updateProto)
	if length(proto) ~= 1 then
		exception("add only one type")
	end

	for typeName,value in pairs(proto) do
		local t = self.types[typeName] -- type
		if t then
			for k,v in pairs(value) do
				local property = t[k]
				if not property then exception("property " .. typeName .. "." .. k .. " does not exist!") end

				local referenceType
				if property.type:find(".", 1, true) then
					local typeAndProperty = util.split(property.type, ".")
					referenceType = typeAndProperty[1]
				else
					referenceType = property.type
				end

				if property.type ~= "id" and property.type ~= "integer" and property.type ~= "float" and property.type ~= "boolean" and property.type ~= "string" then
					local updateProperty, nextUpdateProto
					if updateProto and #updateProto > 0 then
						for j=1,#updateProto do
							if type(updateProto[j]) == "string" then
								if updateProto[j] == k then
									updateProperty = true
								end
							else
								local x, y = next(updateProto[j])
								if x == k then
									nextUpdateProto = y
								end
							end
						end
					end

					if not updateProperty then
						if #v > 0 then
							for i=1,#v do
								addAll(self, {[referenceType] = v[i]}, nextUpdateProto)
							end
						else
							addAll(self, {[referenceType] = v}, nextUpdateProto)
						end
					end
				end
			end

			add(self, proto)
			return proto
		else
			exception("type " .. typeName .. " does not exist!")
		end
	end
end


--
-- delete
--
local function delete (self, proto)
	if length(proto) ~= 1 then
		exception("delete only one type") 
	end

	for typeName,value in pairs(proto) do
		local t = self.types[typeName] -- type
		if t then
			-- check if invalid properties are supplied
			for k,v in pairs(value) do
				if not t[k] then exception("property " .. typeName .. "." .. k .. " does not exist!") end
			end

			local sql = common.delete(self.tableConfig, typeName, value)
			query(self, sql)
		else
			exception("type " .. typeName .. " does not exist!")
		end
	end
end


--
-- update
--
local function update (self, proto, set)
	if length(proto) ~= 1 then
		exception("update only one type") 
	end

	if set then
		for k,v in pairs(proto) do
			if not v.id then exception("object does not have id or it is not persisted") end

			-- update rows & relations
			local r, o, d = splitValueToPropertiesAndReferences(self.tableConfig, self.types, true, k, set, v.id)

			if length(r) > 0 then -- do not add nothing if empty, 'r' does not contain id
				local sql = common.update(self.tableConfig, k, v, r)
				query(self, sql)
			end

			updateRelations(self, d, o)

			set.id = v.id -- set back id in object
			return v.id
		end
	else
		for k,v in pairs(proto) do
			if not v.id then exception("object does not have id or it is not persisted") end
			local id = v.id
			v.id = nil -- update everything but id

			-- update rows & relations
			local r, o, d = splitValueToPropertiesAndReferences(self.tableConfig, self.types, true, k, v, id)

			if length(r) > 0 then -- do not add nothing if empty, 'r' does not contain id
				local sql = common.update(self.tableConfig, k, {id = id}, r)
				query(self, sql)
			end

			updateRelations(self, d, o)

			v.id = id -- set back id in object
			return id
		end
	end
end


--
-- END OF API
--



--
-- connect
--
connectToDatabase = function (connection)
	local driver = require("db.driver." .. connection.rdbms)

	local db = driver:new()
	db:set_timeout(3000)

	local ok, err = db:connect(connection)

	if not ok then
		exception(err)
	end

	return db
end


local function connect (_connection, _types)
	-- get connection parameters --
	local property = require "property"
	local connection = _connection or property.databaseConnection
	
	-- get types
	local types = _types or require("type")

	-- get table config --
	local tableConfig = require("db.api." .. connection.rdbms)
	tableConfig.usePreparedStatement = property.usePreparedStatement

	-- connect to database --
	local db = connectToDatabase(connection)

	-- timestamp & set uuid seed--
	local function timestamp ()
		local res, err = db:query(tableConfig.timestamp.sql)
		if not res then exception(err) end
		return res[1][tableConfig.timestamp.field] * 10000
	end
	uuid.seed(timestamp())

	-- construct persistence api --
	return {
		db = db,
		connection = connection,
		types = types,
		tableConfig = tableConfig,
		operators = operators,
		query = query,
		close = close,
		
		usePreparedStatement = property.usePreparedStatement,
		debugDB = property.debugDB,

		transaction = protectedTransaction,
		protected = protected,

		timestamp = function (self)
			return protected(self, timestamp)
		end,

		createTable = createTable,
		createAllTables = function (self)
			transaction(self, createAllTables)
		end,

		dropTable = dropTable,
		dropAllTables = function (self)
			transaction(self, dropAllTables)
		end,

		updateAllTables = function (self)
			return protected(self, updateAllTables)
		end,

		export = function (self)
			return protected(self, export)
		end,
		import = function (self, data)
			return protected(self, import, data)
		end,

		find = function (self, x1, x2, x3, x4)
			if type(x1) == "table" then
				local proto, references = x1, x2
				local orderBy = proto.orderBy
				if proto.orderBy then proto.orderBy = nil end -- remove orderBy
				local res, res2, res3, res4, res5 = protected(self, select, proto, references, false, nil, orderBy)
				return res, res2, res3, res4, res5
			elseif type(x1) == "number" and type(x2) == "number" then
				local pageNumber, pageSize, proto, references = x1, x2, x3, x4
				local orderBy = proto.orderBy
				if proto.orderBy then proto.orderBy = nil end -- remove orderBy
				local res, res2, res3, res4, res5 = protected(self, select, proto, references, false, {number = pageNumber, size = pageSize}, orderBy)
				return res, res2, res3, res4, res5
			elseif type(x1) == "number" and type(x2) == "table" then
				local pageNumber, pageSize, proto, references = 1, x1, x2, x3
				local orderBy = proto.orderBy
				if proto.orderBy then proto.orderBy = nil end -- remove orderBy
				local res, res2, res3, res4, res5 = protected(self, select, proto, references, false, {number = pageNumber, size = pageSize}, orderBy)
				return res, res2, res3, res4, res5
			else
				exception("illegal arguments")
			end
		end,
		findOne = function (self, proto, references)
			local res, res2, res3, res4, res5 = protected(self, select, proto, references, false, nil)
			if #res == 1 then
				return res[1], res2, res3, res4, res5
			elseif #res == 0 then
				exception(next(proto) .. " must be one not none")
			else
				local json = require "json"
				exception(next(proto) .. " must be one not many ==> " .. json.encode(res))
			end
		end,
		count = function (self, proto)
			if type(proto) ~= "table" then
				exception("illegal arguments")
			end	
			
			-- remove orderBy in count
			if proto.orderBy then proto.orderBy = nil end
			
			local res = protected(self, select, proto, nil, true, nil)
			for _, count in pairs(res[1]) do return count end -- count is the first and only value of the object
		end,
		add = function (self, proto)
			return transaction(self, add, proto)
		end,
		addAll = function (self, proto, updateProto)
			return transaction(self, addAll, proto, updateProto)
		end,
		delete = function (self, proto)
			return protected(self, delete, proto)
		end,
		update = function (self, proto, set)
			return transaction(self, update, proto, set)
		end
	}
end


return {connect = connect}