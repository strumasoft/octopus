-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["/editor/editFile"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/EditorEditFileController.lua";
	};
	["/shop/account/order"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountOrderPageController.lua";
	};
	["/shop/checkout/deliveryMethod"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutDeliveryMethodPageController.lua";
	};
	["/shop/product"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/catalog/ProductPageController.lua";
	};
	["/repository/revert"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/RevertController.lua";
	};
	["/repository/add"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/AddController.lua";
	};
	["/shop/checkout"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutPageController.lua";
	};
	["/repository/commit"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/CommitController.lua";
	};
	["/shop/test/controllers"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/test/TestControllersController.lua";
	};
	["/shop/account/removeAddress"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountRemoveAddressController.lua";
	};
	["/repository/refresh"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/RefreshController.lua";
	};
	["/shop/checkout/confirmation"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutConfirmationPageController.lua";
	};
	["/shop/account/addUpdateAddress"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["requestBody"] = true;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountAddUpdateAddressController.lua";
	};
	["/database/deleteAllReferences"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["requestBody"] = true;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseDeleteAllReferencesController.lua";
	};
	["/shop/home"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/HomePageController.lua";
	};
	["/editor/search"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/EditorSearchController.lua";
	};
	["/editor/compare"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/CompareController.lua";
	};
	["/hello"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo";
			["extension"] = 9;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/controllers/HelloWorldController.lua";
	};
	["/security/login"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/controllers/SecurityLoginPageController.lua";
	};
	["/editor/uploadFile"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["uploadBody"] = "20M";
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/EditorUploadFileController.lua";
	};
	["/shop/account"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountPageController.lua";
	};
	["/database/execute"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["requestBody"] = true;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseExecuteController.lua";
	};
	["/editor/remove"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/RemoveController.lua";
	};
	["/shop/checkout/paymentMethod"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutPaymentMethodPageController.lua";
	};
	["/shop/category"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/catalog/CategoryPageController.lua";
	};
	["/editor/createDirectory"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/CreateDirectoryController.lua";
	};
	["/repository/fileDiff"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/FileDiffController.lua";
	};
	["/shop/account/orders"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountOrdersPageController.lua";
	};
	["/shop/test/modules"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/test/TestModulesController.lua";
	};
	["/editor/rename"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/RenameController.lua";
	};
	["/shop/checkout/placeOrder"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutPlaceOrderController.lua";
	};
	["/editor"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/EditorController.lua";
	};
	["/repository/logHistory"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/RepositoryLogHistoryController.lua";
	};
	["/repository/fileHistory"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/RepositoryFileHistoryController.lua";
	};
	["/editor/createFile"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/CreateFileController.lua";
	};
	["/repository/merge"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/MergeController.lua";
	};
	["/database/add"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseAddController.lua";
	};
	["/repository/status"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/RepositoryStatusController.lua";
	};
	["/shop/changeCountry"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/ChangeCountryController.lua";
	};
	["/shop/checkout/setPaymentMethod"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutSetPaymentMethodController.lua";
	};
	["/shop/checkout/setAddress"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutSetAddressController.lua";
	};
	["/repository/commitHistory"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/RepositoryCommitHistoryController.lua";
	};
	["/shop/checkout/addresses"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutAddressesPageController.lua";
	};
	["/product"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo";
			["extension"] = 9;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/controllers/ProductDetailController.lua";
	};
	["/"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo";
			["extension"] = 9;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/demo/src/controllers/IndexController.lua";
	};
	["/shop/checkout/addAddress"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["requestBody"] = true;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutAddAddressController.lua";
	};
	["/repository/delete"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/DeleteController.lua";
	};
	["/security/register"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/controllers/SecurityRegisterPageController.lua";
	};
	["/shop/cart"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CartPageController.lua";
	};
	["/editor/save"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["requestBody"] = "10000k";
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/SaveController.lua";
	};
	["/repository/fileRevisionContent"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/FileRevisionContentController.lua";
	};
	["/editor/fileContent"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/FileContentController.lua";
	};
	["/security/loginUser"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
			["requestBody"] = true;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/controllers/SecurityLoginUserController.lua";
	};
	["/editor/directory"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor";
			["extension"] = 5;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/editor/src/controllers/operations/DirectoryController.lua";
	};
	["/shop/cart/add"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/AddToCartController.lua";
	};
	["/database/addReference"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseAddReferenceController.lua";
	};
	["/shop/register"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/RegisterPageController.lua";
	};
	["/database/deleteReference"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["requestBody"] = true;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseDeleteReferenceController.lua";
	};
	["/database/delete"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["requestBody"] = true;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseDeleteController.lua";
	};
	["/shop/login"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/LoginPageController.lua";
	};
	["/database/edit"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseEditController.lua";
	};
	["/database"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["access"] = "DatabaseRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseController.lua";
	};
	["/security/registerUser"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security";
			["extension"] = 4;
			["requestBody"] = true;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/security/src/controllers/SecurityRegisterUserController.lua";
	};
	["/shop/checkout/address"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutAddressPageController.lua";
	};
	["/database/save"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database";
			["extension"] = 7;
			["requestBody"] = true;
			["access"] = "DatabaseThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/database/src/controllers/DatabaseSaveController.lua";
	};
	["/shop/account/addresses"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountAddressesPageController.lua";
	};
	["/shop/account/address"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/account/AccountAddressPageController.lua";
	};
	["/repository/update"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository";
			["extension"] = 6;
			["access"] = "EditorThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/repository/src/controllers/operations/UpdateController.lua";
	};
	["/shop/cart/update"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/UpdateProductEntryController.lua";
	};
	["/shop/checkout/reviewOrder"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopRedirectOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutReviewOrderPageController.lua";
	};
	["/shop/checkout/setDeliveryMethod"] = {
		[1] = {
			["octopusHostDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions";
			["extensionDir"] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop";
			["extension"] = 8;
			["access"] = "ShopThrowErrorOnSessionTimeoutFilter";
		};
		[2] = "/data/Project/octopus_orig/bin/unix/../../sites/extensions/shop/src/controllers/checkout/CheckoutSetDeliveryMethodController.lua";
	};
}
return obj1
