# Octopus - The Lua Web Framework

Wiki
===============================

[Extension](https://github.com/strumasoft/octopus/wiki/Extension)

[Graphical widget](https://github.com/strumasoft/octopus/wiki/Graphical-widget)

[Object relational mapping](https://github.com/strumasoft/octopus/wiki/Object-relational-mapping)

[Security](https://github.com/strumasoft/octopus/wiki/Security)

[Editor](https://github.com/strumasoft/octopus/wiki/Editor)

[Revision control](https://github.com/strumasoft/octopus/wiki/Revision-control)

[Database administration](https://github.com/strumasoft/octopus/wiki/Database-administration)


Introduction
============

Octopus is web framework based on [nginx](https://www.nginx.com/), [luajit](https://luajit.org/) and [lua-nginx-module](https://github.com/openresty/lua-nginx-module). It contains an automated process for creating all the required configurations for [lua-nginx-module](https://github.com/openresty/lua-nginx-module). Octopus is capable of hosting many websites at the same time. Every website is made up of units called extensions that aggregate everything needed for an MVC architecture.

The heart of the system is the build process which creates all the necessary nginx configurations, create widgets, creates type system and autowire modules in dependency injection style.
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
sudo apt-get install libssl-dev gcc g++ build-essential libtool zlib1g
```

Set Up
============

Minimum set up script:

```bash
cd bin/unix
. ./server.sh install
. ./server.sh restart
```
then just open [localhost:8787](http://localhost:8787)

Demo Shop
============

* Create database and set up database connection - databaseConnection object in [config.lua](extensions/config.lua)
* Create tables and import data - go to [localhost:8787/database](http://localhost:8787/database) and execute
```lua
db:dropAllTables()
db:createAllTables()
db:import("shopImport")
```
* use the following credentials - username 'test@test.com' and password 'test'

Copyright and License
=====================

Copyright (C) 2015-2024, StrumaSoft

All rights reserved. BSD license.
