Octopus - The Lua Web Platform
==============================

Home page at [cyberz.eu](http://cyberz.eu/octopus)

Documentation at [cyberz.eu](http://cyberz.eu/octopus/documentation)

Extensions at [cyberz.eu](http://cyberz.eu/octopus/extensions)

Introduction
============

Octopus is automated process for creating configuration for the excellent [lua-nginx-module](https://github.com/openresty/lua-nginx-module). It can host many aplications/sites. Every aplication/site hosted by octopus is made up of a number of extensions, where every extension is aggregation of logically connected files.

The heart of the system is the build process who creates all the necessary nginx configurations, create widgets, creates type system and autowire modules in dependency injection style.

Under `bin/unix` there is a file called `build.lua` where all the aplications/sites that will be hosted are named. All extensions of a single aplication/site have configuration, check `extensions/config_unix.lua`, that is poined in the `build.lua` file. Building octopus happens in a sigle command:

```bash
# build octopus
lua build.lua
```

Also in the same direcotry `bin/unix` there is a file called `server.sh` which is responsible for installing, starting, stoping and restarting the server:

```bash
# install nginx
. ./server.sh install
# build octopus and restart server
. ./server.sh restart
# start server
. ./server.sh start
# stop server
. ./server.sh stop
```

Set Up
============

Minimum set up script:

```bash
cd octopus/bin/unix
. ./server.sh install
. ./server.sh restart
```
then just open [localhost:7878](http://localhost:7878)

Important configuration files: [config_unix.lua](extensions/config_unix.lua), [build.lua](bin/unix/build.lua), [server.sh](bin/unix/server.sh)


Database, users and security
============
* Set up database connection - databaseConnection object in [config_unix.lua](extensions/config_unix.lua)
* Import test user from security extension [import.lua](extensions/security/src/import.lua) file in [localhost:7878/database](http://localhost:7878/database)
```lua
db:dropAllTables()
db:createAllTables()
db:import("securityImport")
db:import("shopImport")
```
* Enable security - set `requireSecurity = true` in globalParameters object in [config_unix.lua](extensions/config_unix.lua)

Copyright and License
=====================

Copyright (C) 2015, Lazar Gyulev, cyberz.eu@gmail.com, www.cyberz.eu

All rights reserved. BSD license.