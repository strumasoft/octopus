#! /bin/bash

### prerequisites ###
# sudo apt-get install libssl-dev gcc g++ build-essential libtool zlib1g

## install ##
# bash server.sh install 2>&1 | less

# cd octopus/bin/unix
working_dir=$(pwd)

export download_dir="$working_dir/downloads"
export luajit_install_dir="$working_dir/luajit"
export lib_dir="$working_dir/lib"
export ace_dir="$working_dir/../../extensions/baseline/static/ace"
export nginx_install_dir="$working_dir"

export LUAJIT_BIN=$luajit_install_dir/bin
export LUAJIT_LIB=$luajit_install_dir/lib
export LUAJIT_INC=$luajit_install_dir/include/luajit-2.1

export GITHUB=https://codeload.github.com

function download_archive {
  file_name="$download_dir/$1.$2"
  url=$3

  echo "[DOWNLOAD] $url -> $file_name"
  wget -c -O "$file_name" $url

  if [ ! -s "$file_name" ]; then
    echo "[ERROR DOWNLOAD] $url -> $file_name"
    exit 1
  fi

  tar -xzf "$file_name" -C $download_dir
}


function download_repo_and_install {
  owner=$1
  repo=$2
  version=$3
  folder=$4
  install_dir=$5
  download_archive $repo tar.gz "$GITHUB/$owner/$repo/tar.gz/refs/tags/v$version"
  cp -R "$download_dir/$repo-$version/$folder"/* $install_dir
}


function nginx_install {
  # make new dirs
  rm -rf logs
  mkdir logs
  rm -rf $download_dir
  mkdir $download_dir
  rm -rf $luajit_install_dir
  mkdir $luajit_install_dir
  rm -rf $lib_dir
  mkdir $lib_dir
  rm -rf $ace_dir
  mkdir $ace_dir


  # libraries
  download_repo_and_install ajaxorg ace-builds 1.42.0 src-min $ace_dir
  download_repo_and_install openresty lua-resty-core 0.1.31 lib $lib_dir
  download_repo_and_install openresty lua-resty-lrucache 0.15 lib $lib_dir


  # nginx
  nginx=nginx
  nginx_version=1.27.2
  nginx_url=http://nginx.org/download/nginx-$nginx_version.tar.gz
  download_archive $nginx tar.gz $nginx_url


  # ngx_devel_kit
  ngx_devel_kit=ngx_devel_kit
  ngx_devel_kit_version=0.3.3
  ngx_devel_kit_url=$GITHUB/vision5/ngx_devel_kit/tar.gz/refs/tags/v$ngx_devel_kit_version
  download_archive $ngx_devel_kit tar.gz $ngx_devel_kit_url


  # lua-nginx-module
  lua_nginx_module=lua-nginx-module
  lua_nginx_module_version=0.10.28
  lua_nginx_module_url=$GITHUB/openresty/lua-nginx-module/tar.gz/refs/tags/v$lua_nginx_module_version
  download_archive $lua_nginx_module tar.gz $lua_nginx_module_url


  # PCRE
  pcre=pcre2
  pcre_version=pcre2-10.44
  pcre_url=$GITHUB/PCRE2Project/pcre2/tar.gz/refs/tags/$pcre_version
  download_archive $pcre tar.gz $pcre_url
  cd $download_dir/$pcre-$pcre_version
  ./autogen.sh


  # zlib
  zlib=zlib
  zlib_version=1.3.1
  zlib_url=$GITHUB/madler/zlib/tar.gz/refs/tags/v$zlib_version
  download_archive $zlib tar.gz $zlib_url


  # install LuaJIT
  luajit=luajit2
  luajit_version=2.1-20250117
  luajit_url=$GITHUB/openresty/luajit2/tar.gz/refs/tags/v$luajit_version
  download_archive $luajit tar.gz $luajit_url
  cd $download_dir/$luajit-$luajit_version
  make -j$(nproc)
  make install PREFIX=$luajit_install_dir


  # install lfs
  lfs=luafilesystem
  lfs_version=1_8_0
  lfs_url=$GITHUB/keplerproject/luafilesystem/tar.gz/refs/tags/v$lfs_version
  download_archive $lfs tar.gz $lfs_url
  cd $download_dir/$lfs-$lfs_version
cat <<'EOF' > config
LUA_LIBDIR=$(LUAJIT_LIB)
LUA_INC= $(LUAJIT_INC)
LIB_OPTION= -shared
LIBNAME= $T.so.$V
WARN= -O2 -Wall -fPIC -W -Waggregate-return -Wcast-align -Wmissing-prototypes -Wnested-externs -Wshadow -Wwrite-strings -pedantic
INCS= -I$(LUA_INC)
CFLAGS= $(WARN) $(INCS)
CC= gcc
EOF
  make
  make install


  # install nginx
  cd "$download_dir/$nginx-$nginx_version"
  ./configure --prefix=$nginx_install_dir \
    --sbin-path=$nginx_install_dir/nginx \
    --conf-path=$nginx_install_dir/nginx.conf \
    --pid-path=$nginx_install_dir/nginx.pid \
    --with-pcre=../$pcre-$pcre_version \
    --with-pcre-jit \
    --with-zlib=../$zlib-$zlib_version \
    --with-http_ssl_module \
    --add-module=../$ngx_devel_kit-$ngx_devel_kit_version \
    --add-module=../$lua_nginx_module-$lua_nginx_module_version
  make -j$(nproc)
  make install


  # return back to woring directory
  cd "$working_dir"
}


function nginx_start {
  export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
  ./nginx -c nginx.conf
}


function nginx_stop {
  export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
  ./nginx -s stop
}


# $1 is the name of the build
function nginx_build {
  $LUAJIT_BIN/luajit build.lua $1
}


function nginx_clear {
  $LUAJIT_BIN/luajit build.lua clear
}


# $1 is the name of the build
function nginx_restart {
  $LUAJIT_BIN/luajit build.lua $1

  if [ $? -eq 0 ]; then
    export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
    ./nginx -s stop
    ./nginx -c nginx.conf

    echo "" > logs/error.log
    echo "" > logs/access.log
    tail -f logs/error.log
  fi
}


# crontab -e
# */5 * * * * /octopus/bin/unix/server.sh reload
function nginx_reload {
  if [ -f server.reload ]; then
    export LD_LIBRARY_PATH="$LUAJIT_LIB":$LD_LIBRARY_PATH
    ./nginx -s stop
    ./nginx -c nginx.conf
    
    rm server.reload
  fi
}


if [ -z "$1" ]; then
  echo "no operation!"
elif [ "$1" == "install" ]; then
  echo "install server..."
  nginx_install
elif [ "$1" == "build" ]; then
  echo "build server..."
  nginx_build $2
elif [ "$1" == "clear" ]; then
  echo "clear server..."
  nginx_clear
elif [ "$1" == "stop" ]; then
  echo "stop server..."
  nginx_stop
elif [ "$1" == "start" ]; then
  echo "start server..."
  nginx_start
elif [ "$1" == "restart" ]; then
  echo "restart server..."
  nginx_restart $2
elif [ "$1" == "reload" ]; then
  echo "reload server..."
  nginx_reload
else
  echo "unknown operation!"
fi
