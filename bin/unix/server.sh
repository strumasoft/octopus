#! /bin/bash


### prerequisites ###
# sudo apt-get install libssl-dev
# sudo apt-get install gcc g++ build-essential
# luarocks install luafilesystem --tree=lualib

current_dir=$(pwd)

export destination_folder="$current_dir/downloads"
export luajit_install="$current_dir/luajit"
export nginx_install="$current_dir"

export LUAJIT_BIN=$luajit_install/bin
export LUAJIT_LIB=$luajit_install/lib
export LUAJIT_INC=$luajit_install/include/luajit-2.0


function download {
	file_name="$destination_folder/$1.$2"
	url=$3

	wget -c -O "$file_name" $url
	tar -xzf "$file_name" -C $destination_folder
}


function nginx_install {
	# make new dirs
	rm -rf $destination_folder
	mkdir $destination_folder
	rm -rf $luajit_install
	mkdir $luajit_install
	rm -rf logs
	mkdir logs


	# nginx
	nginx=nginx
	nginx_version=1.10.2
	nginx_url=http://nginx.org/download/nginx-$nginx_version.tar.gz
	download $nginx tar.gz $nginx_url


	# ngx_devel_kit
	ngx_devel_kit=ngx_devel_kit
	ngx_devel_kit_version=0.3.0
	ngx_devel_kit_url=https://github.com/simpl/ngx_devel_kit/archive/v$ngx_devel_kit_version.tar.gz
	download $ngx_devel_kit tar.gz $ngx_devel_kit_url


	# lua-nginx-module
	lua_nginx_module=lua-nginx-module
	lua_nginx_module_version=0.10.7
	lua_nginx_module_url=https://github.com/openresty/lua-nginx-module/archive/v$lua_nginx_module_version.tar.gz
	download $lua_nginx_module tar.gz $lua_nginx_module_url


	# install LuaJIT
	luajit=LuaJIT
	luajit_version=2.0.4
	luajit_url=http://luajit.org/download/LuaJIT-$luajit_version.tar.gz
	download $luajit tar.gz $luajit_url
	cd $destination_folder/$luajit-$luajit_version
	make
	make install PREFIX=$luajit_install


	# install lfs
	# config/lfs.config
	lfs=luafilesystem
	lfs_version=v_1_6_3
	lfs_url=https://github.com/keplerproject/luafilesystem/archive/$lfs_version.tar.gz
	download $lfs tar.gz $lfs_url
	cd $destination_folder/$lfs-$lfs_version
	cat $nginx_install/config/lfs.config > config
	make
	make install


	# install PCRE
	pcre=pcre
	pcre_version=8.39
	pcre_url=ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$pcre-$pcre_version.tar.gz
	download $pcre tar.gz $pcre_url


	# install zlib
	# apt-get install zlib1g-dev
	zlib=zlib
	zlib_version=1.2.11
	zlib_url=http://zlib.net/zlib-$zlib_version.tar.gz
	download $zlib tar.gz $zlib_url


	# install nginx
	cd "$destination_folder/$nginx-$nginx_version"
	./configure --prefix=$nginx_install \
			--sbin-path=$nginx_install/nginx \
			--conf-path=$nginx_install/nginx.conf \
			--pid-path=$nginx_install/nginx.pid \
			--with-pcre=../$pcre-$pcre_version \
			--with-zlib=../$zlib-$zlib_version \
			--with-http_ssl_module \
			--add-module=../$ngx_devel_kit-$ngx_devel_kit_version \
			--add-module=../$lua_nginx_module-$lua_nginx_module_version

	make -j2
	make install


	# return back to woring directory
	cd "$current_dir"
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





if [ -z "$1" ]; then
	echo "no operation!"
elif [ "$1" == "install" ]; then
	echo "install server..."
	nginx_install
elif [ "$1" == "build" ]; then
	echo "build server..."
	nginx_build $2
elif [ "$1" == "stop" ]; then
	echo "stop server..."
	nginx_stop
elif [ "$1" == "start" ]; then
	echo "start server..."
	nginx_start
elif [ "$1" == "restart" ]; then
	echo "restart server..."
	nginx_restart $2
else
	echo "unknown operation!"
fi