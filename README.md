Octopus - The Lua Web Framework
===============================

Home page at [cyberz.eu](http://cyberz.eu/octopus)

Documentation at [cyberz.eu](http://cyberz.eu/octopus/documentation)

Extensions at [cyberz.eu](http://cyberz.eu/octopus/extensions)

Introduction
============

Octopus is automated process for creating configuration for the excellent [lua-nginx-module](https://github.com/openresty/lua-nginx-module). It can host many aplications/sites. Every aplication/site hosted by octopus is made up of a number of extensions, where every extension is aggregation of logically connected files.

The heart of the system is the build process who creates all the necessary nginx configurations, create widgets, creates type system and autowire modules in dependency injection style.
[build.lua](bin/unix/build.lua) together with [config.lua](extensions/config.lua) are responsible for configurating the build/generation process, while [server.sh](bin/unix/server.sh) is responsible for the actual building, installing, starting, stoping and restarting the server:

```bash
# go to bin directory
cd bin/unix
# install nginx
. ./server.sh install
# build octopus and restart server
. ./server.sh restart
# build
. ./server.sh build
# start server
. ./server.sh start
# stop server
. ./server.sh stop
```

Prerequisites
============

```
sudo apt-get install libssl-dev
sudo apt-get install gcc g++ build-essential
sudo apt-get install lua5.1
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

Database, users and security
============

* Set up database connection - databaseConnection object in [config.lua](extensions/config.lua)
* Import test user from security extension [import.lua](extensions/security/src/import.lua) file in [localhost:7878/database](http://localhost:7878/database)
```lua
db:dropAllTables()
db:createAllTables()
db:import("securityImport")
db:import("shopImport")
```
* Enable security - set `requireSecurity = true` in globalParameters object in [config.lua](extensions/config.lua) and edit database connection parameters

Copyright and License
=====================

Copyright (C) 2015, Lazar Gyulev, cyberz.eu@gmail.com, www.cyberz.eu

All rights reserved. BSD license.