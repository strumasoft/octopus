extensions = {"core", "baseline", "orm", "security", "editor", "repository", "database", "shop", "demo"}


port = 7878
errorLog = "#error_log stderr;"
accessLog = "access_log off;"
rootPath = "root " .. extensionsDir .. ";"
staticLocation = [[location /static/ {}]]
includeDrop = [[#include drop.conf;]]
maxBodySize = "50k"
minifyJavaScript = false
minifyCommand = [[java -jar ../yuicompressor-2.4.8.jar %s -o %s]]
databaseConnection = {
    rdbms       =   "postgres",
    host        =   "127.0.0.1",
    port        =   5432, 
    database    =   "demo",
    user        =   "demo",
    password    =   "demo",
    compact     =   false
}
globalParameters = {
    extensionsDir = extensionsDir,
    sourceCtxPath = "",
    cryptoCommand = [[java -jar ../crypto.jar]],
    requireSecurity = false,
    sessionTimeout = 3600, -- 1h
    domain = "", -- localhost / the host that sent it
    debugDB = false,
    DNSResolver = "8.8.8.8",
}


requestBody = [[

    # force reading request body (default off)
	lua_need_request_body on;
	client_max_body_size {{maxBodySize}};
	client_body_buffer_size {{maxBodySize}};

]]


nginxLocationTemplate = [[
		
	location {{url}} {
		# MIME type determined by default_type:
		default_type 'text/html';
		
		{{resolver}}
		
		{{requestBody}}
		
		# ngx.var.extensionsDir
        set $extensionsDir '{{extensionsDir}}';
		
		{{access}}
		
		{{script}}
	}
]]


nginxStaticLocationTemplate = [[
		
	location {{url}} {}
		
]]


nginxForbidStaticLocationTemplate = [[

    location ~* {{url}} {access_log off; log_not_found off; deny all;}
    
]]


nginxConfigTemplate = [[

    http {
    		
    	lua_package_path '../?.lua;{{externalPaths}};';
      
    	lua_package_cpath '{{externalCPaths}};';
    	
    	init_by_lua 'require = require "autowire"';
    	
    	types {
    		text/html html;
    	    text/css css;
    	    application/javascript js;
    	    image/png png;
    	    image/gif gif;
    	    image/jpeg jpеg;
    	    image/jpg jpg;
    	    image/x-icon ico;
    	}
    	
    	# Regular servers
    	server {
    	    {{errorLog}}
    	
    	    {{accessLog}}
    	
    		listen {{port}};
    		
    		{{server_name}}
    		
    		{{ssl_certificate}}
    		
    		{{rootPath}}
    		
    		{{forbidStaticLocations}}
    		
    		# This block will catch static file requests, such as images, css, js
    		# The ?: prefix is a 'non-capturing' mark, meaning we do not require
    		# the pattern to be captured into $1 which should help improve performance
    		location ~* \.(?:ico|css|js|gif|jpe?g|png)$ {
    			# Some basic cache-control for static files to be sent to the browser
    			expires max;
    			add_header Pragma public;
    			add_header Cache-Control "public, must-revalidate, proxy-revalidate";
    		}
    		
    		# remove the robots line if you want to use wordpress' virtual robots.txt
    		location = /robots.txt  { access_log off; log_not_found off; }
    		location = /favicon.ico { access_log off; log_not_found off; }	
     
    		# this prevents hidden files (beginning with a period) from being served
    		location ~ /\.          { access_log off; log_not_found off; deny all; }
    		
    		{{staticLocation}}
    		
    		{{staticLocations}}
    		
    		lua_code_cache off;
    		
    		{{locations}}
    		
    		{{includeDrop}}
    		
    	} # end of server
    	
    } # end of http
    
    events { 
        worker_connections {{workerConnections}};
    } # end of events
    
    worker_processes {{workerProcesses}};
    
]]