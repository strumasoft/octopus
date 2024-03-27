### Introduction

**luaorm** let's you define types and persist their instances to the underlying database, currently it supports two databases: MySQL (via [lua-resty-mysql](https://github.com/openresty/lua-resty-mysql)) and PostgreSQL (via [postgresql.lua](https://github.com/strumasoft/luaorm/blob/main/rocky/postgresql.lua)) which is a refactored version of the [pgmoon PostgreSQL driver](https://github.com/leafo/pgmoon) with less external dependencies. **luaorm** can be used as an ORM for [OpenResty](https://github.com/openresty), check the integration in  [Octopus](https://github.com/strumasoft/octopus/blob/master/extensions/core/src/database.lua), but it can be also used as an ORM for native Lua scripts, outside of containers and servers, with or without TLS encryption, see the example [tests](https://github.com/strumasoft/luaorm/tree/main/test). The persistence layer maps each Lua object to a database table row, it can connect, search, add, update, delete, execute transactions and finally close the connection to the database. All queries performed by the persistence layer can be executed as plain SQL or as prepared statements by setting the property **usePreparedStatement** to **true**.


### Dependencies
Inside [OpenResty](https://github.com/openresty) or [Octopus](https://github.com/strumasoft/octopus) the **luaorm** depends only on OpenSSL
```bash
sudo apt install openssl libssl-dev
```
Outside of containers, when **luaorm** is run from native Lua scripts it depends from OpenSSL, luasocket and luasec, see the example [tests](https://github.com/strumasoft/luaorm/tree/main/test)
```bash
sudo apt install openssl libssl-dev
sudo apt install luarocks
sudo luarocks install luasocket
sudo luarocks install luasec
```


### Type system

```lua
return {
  localizedString = {
    content             =   {type = "string", length = 1000},
    locale              =   {type = "string", length = 2},
  },
  
  country = {
    isocode             =   {type = "string", length = 2, unique = true},
    flag                =   "string",
    currency            =   hasOne("currency", "countries"),
    locale              =   {type = "string", length = 2},
  },

  currency = {
    isocode             =   {type = "string", length = 3, unique = true},
    symbol              =   "string",
    symbolBeforeAmount  =   "boolean",
    countries           =   hasMany("country", "currency")
  },
  
  price = {
    currencyIsocode     =   {type = "string", length = 3},
    value               =   "float",
    net                 =   "boolean",
  },
  
  product = {
    code                =   {type = "string", unique = true},
    name                =   hasMany("localizedString"),
    price               =   "price",
  },
  
  user = {
    email               =   {type = "string", unique = true},
    addresses           =   hasMany("address", "user"),
  },
  
  address = {
    user                =   hasOne("user", "addresses"),
    country             =   "string",
    city                =   "string",
    line1               =   "string",
    line2               =   "string",
  },
}
```

Custom types are arbitrarily defined. They consist of properties and linkage to the corresponding property type which can be other custom type or built-in type. Built-in types are **id**, **integer**, **float**, **boolean** and **string**. You do not need to define a property for unique identification, **luaorm** automatically creates one for you called **id** that has the type **id**. For every type a table is created and all properties that have a built-in type are directly mapped to columns in that table. Every property that has a custom type is mapped to a new table with a name aggregated from both names of the relation and holds the 2 primary keys.

Cardinality of both ends of the relation can be **one** or **many**, so all 4 table cardinalities are supported: **one-to-one**, **one-to-many**, **many-to-one** and **many-to-many**.

If you want the cardinality from one end to be **one** just set property type to *type* like `address.user = "user"` or use keyword **hasOne** like `address.user = hasOne("user")`. If you want the relation to be bidirectional add to **hasOne** the referred type's property name like `address.user = hasOne("user", "addresses")` and in the referred type add the backward reference `user.addresses = hasMany("address", "user")`.

If you want the cardinality from one end to be **many** use keyword **hasMany** like `product.name = hasMany("localizedString")` or for bidirectional relation add to **hasMany** the referred type's property name like `currency.countries = hasMany("country", "currency")` and in the referred type add the backward reference `country.currency = hasOne("currency", "countries")`.


### The luaorm interface

The **luaorm** exposes two methods, one called **connect** for retrieving a database connection and second called **build** to build the type system for persistence to a file. The return value from **connect** can be used to perform search, add, update, delete, execute transactions and finally close the connection to the database.

```lua
local luaorm = require "rocky.luaorm"
local types = require "test.types"

local db = luaorm.connect{
  driver = function ()
    require("rocky.socket").ssl = {
      mode = "client",
      protocol = "tlsv1_3",
      key = "./cert_key.pem",
      certificate = "./cert.pem",
      options = {"all"},
    }
    return require "rocky.postgresql"
  end,
  types = types,
  usePreparedStatement = true,
  debugDB = true,
  rdbms = "postgresql", 
  host = "127.0.0.1",
  port = 5432,
  database = "demodb",
  user = "demouser",
  password = "demopass",
  charset = "utf8",
  max_packet_size = 1024 * 1024,
  ssl = true
}
local op = db:operators()

local product123 = db:findOne{product = {id = op.equal("123")}}

db:close()
```

* keep in mind that in Lua you can always omit the parenthesis `()` if the function argument is only one value like in the `db:connect({})` and in `db:findOne({})`.

---

**db:operators()** - get **select** operators

Call `local op = db:operators()` to get **select** operators like `op.equal("foo")` or `op.like("%bar%")`.

---

**db:query(sql, doNotThrow)** - execute query, return response or throw exception

This method is not part of the persistence layer. It is left only for convenience for tasks that really require writing hard coded SQL: `local res = db:query("select version()")`. If **doNotThrow** is true return second variable describing the error or throw exception otherwise.

---

**db:close()** - close database connection

After this method is called the database connection becomes stale and no more queries can be executed.

---

**db:createTable(typeName)** - create table with name **typeName**

---

**db:createAllTables()** - create all required tables for the type system 

---

**db:dropTable(typeName)** - drop table with name **typeName**

---

**db:dropAllTables()** - drop all tables in the database 

---

**db:export()** - export all objects from the database to **import.lua** file in the extensions directory

---

**db:import(import)** - import objects to database, the argument **import** can be either: 

- **nil** - then file **import.lua** in the extensions directory will be imported.
- **string** - then that module will be required and imported.
- **table** - then the table with objects will be imported.

---

**db:find(proto, references)** - find objects with prototype **proto**

Search for objects with prototype **proto** with format `{type = value}` and return a list (can be empty) of found objects or throw exception. Only properties from the built-in types will be populated. The argument **references** is also prototype but for properties that will be pre-populated - useful when the searched objects will be directly passed to front end. The result can be ordered by adding orderBy clause after type prototype.

```lua
-- return product with code p1
return db:find({product = {code = op.equal("p1")}}, {
  "pictures",
  "prices",
  {name = {locale = "en"}}    
})

-- return all product attributes that belong to all products from category:
--      c1 - manufacturer & size
--      c2 - manufacturer
--      c3 - size
--      c4 - nothing
return db:find({
  productAttribute = {
    values = {
      products = {
        categories = {code = op.equal("c1")}
      }
    }
  }
})

-- return all categories that start with letter c
return db:find({category = {code = op.like("c%")}})

-- return all subcategories of c1
return db:find({
  category = {
    supercategories = {
      code = op.equal("c1")
    }
  }
})

-- return all products ordered by code and then by id, pre-populate its categories
return db:find({
  product = {}, 
  orderBy = {op.asc("code"), op.asc("id")}
  }, {"categories"})

-- return all delivery methods and pre-populate name and description in en locale
local locale = "en"
return db:find({deliveryMethod = {}}, {
  {name = {locale = locale}},
  {description = {locale = locale}},
})
```

---

**db:find(pageNumber, pageSize, proto, references)** - find objects in page **pageNumber** with size **pageSize**

The same as **db:find(proto, references)** but adds pagination.

---

**db:find(N, proto, references)** - find first **N** objects

The same as **db:find(proto, references)** but finds first **N** objects

---

**db:findOne(proto, references)** - find only one object

The same as **db:find(proto, references)** but assures that only one object will be returned otherwise an exception will be thrown: **must be one not none** or **must be one not many**

---

**db:count(proto, references)** - count found objects

Similar to **db:find(proto, references)** but just count the found objects.

---

**db:add(proto)** - add object, return its unique identifier or throw exception

The format of the **proto** prototype is `{type = value}`.

```lua
local userId = db:add({user = {email = "foo@bar.baz"}}) 

local address = {
  user = userId,
  country = "Bulgaria",
  city = "Sofia",
}

local addressId = db:add({address = address})
```

---

**db:update(proto)** - update object

The format of the **proto** prototype is `{type = value}`.

```lua
local userEmail1 = "foo@bar.baz"
local userEmail2 = "qux@bar.baz"

db:delete({user = {email = userEmail1}})
db:delete({user = {email = userEmail2}})

local userId1 = db:add({user = {email = userEmail1}})
local userId2 = db:add({user = {email = userEmail2}})

local address = {
  user = userId1,
  country = "Bulgaria",
  city = "Sofia",
}

db:add({address = address})

address.user = db:findOne({user = {id = op.equal(userId2)}})

db:update({address = address})
```

---

**db:delete(proto)** - delete object

The format of the **proto** prototype is `{type = value}`.

```lua
db:delete({user = {email = "foo@bar.baz"}})
```

---

**db:transaction(function, ...)** - execute **function** as a transaction

Whenever you need to execute more than one query and to be sure that they will either succeed all as a group or nothing happen then you need a transaction! Wrap all required queries in a function and pass it as the first argument to **db:transaction** with any extra arguments after the function name. The method will either return a response or throw an exception.

```lua
local function f (foo, bar, baz)
  -- do some queries --
end

-- execute transation but do not catch exeption
local res = db:transaction(f, "foo", bar, "baz")

-- execute transation and catch exeption
local ok, res = pcall(db.transaction, db, f, "foo", bar, "baz")
```

---

### Copyright and License

Copyright (C) 2024, StrumaSoft

All rights reserved. BSD license.
