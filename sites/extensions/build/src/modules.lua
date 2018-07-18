-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["cartService"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/modules/CartService.lua";
	};
	["db.driver.mysql"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm";
			["extension"] = 3;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm/src/db/driver/mysql.lua";
	};
	["utf8"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/utf8.lua";
	};
	["db.api.common"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm";
			["extension"] = 3;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm/src/db/api/common.lua";
	};
	["DemoProductService"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo";
			["extension"] = 9;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/modules/DemoProductService.lua";
	};
	["property"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/property.lua";
	};
	["http"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/http.lua";
	};
	["http_headers"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/http_headers.lua";
	};
	["Editor"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/modules/Editor.lua";
	};
	["param"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/param.lua";
	};
	["builder"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/builder.lua";
	};
	["db.api.postgres"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm";
			["extension"] = 3;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm/src/db/api/postgres.lua";
	};
	["Directory"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/modules/Directory.lua";
	};
	["db.api.mysql"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm";
			["extension"] = 3;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm/src/db/api/mysql.lua";
	};
	["GIT"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/modules/GIT.lua";
	};
	["securityImport"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/import.lua";
	};
	["json"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/json.lua";
	};
	["persistence"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/persistence.lua";
	};
	["htmltemplates"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/htmltemplates.lua";
	};
	["eval"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/eval.lua";
	};
	["priceService"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/modules/PriceService.lua";
	};
	["crypto"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/crypto.lua";
	};
	["BaselineHtmlTemplate"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline";
			["extension"] = 2;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/baseline/src/BaselineHtmlTemplate.lua";
	};
	["utf8data"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/utf8data.lua";
	};
	["template"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/template.lua";
	};
	["fileutil"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/fileutil.lua";
	};
	["tests"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/tests.lua";
	};
	["countryService"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/modules/CountryService.lua";
	};
	["exceptionHandler"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/modules/ExceptionHandler.lua";
	};
	["exit"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/exit.lua";
	};
	["db.driver.postgres"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm";
			["extension"] = 3;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm/src/db/driver/postgres.lua";
	};
	["localeService"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/modules/LocaleService.lua";
	};
	["userService"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/modules/UserService.lua";
	};
	["shopImport"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/import.lua";
	};
	["cookie"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/cookie.lua";
	};
	["testUser"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/testUser.lua";
	};
	["SVN"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/modules/SVN.lua";
	};
	["access"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/access.lua";
	};
	["types"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/types.lua";
	};
	["upload"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/upload.lua";
	};
	["exception"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/exception.lua";
	};
	["date"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/date.lua";
	};
	["database"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm";
			["extension"] = 3;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//orm/src/database.lua";
	};
	["localization"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/localization.lua";
	};
	["modules"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build";
			["extension"] = 0;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/build/src/modules.lua";
	};
	["parse"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/parse.lua";
	};
	["uuid"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/uuid.lua";
	};
	["util"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/util.lua";
	};
	["stacktrace"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core";
			["extension"] = 1;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/../common//core/src/stacktrace.lua";
	};
}
return obj1
