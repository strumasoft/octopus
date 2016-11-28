local config = {} -- extension configuration

config.property = {
	-- country & locale --
	defaultCountryIsocode = "GB",

	----------
	-- URLs --
	----------
	testUrl = "/test",

	shopUrl = "/shop",

	-- home --
	shopHomeUrl = "/home",
	changeLocaleUrl = "/changeLocale",
	changeCountryUrl = "/changeCountry",

	-- catalog --
	productUrl = "/product",
	categoryUrl = "/category",

	-- account --
	accountUrl = "/account",
	loginUrl = "/login",
	registerUrl = "/register",

	accountOrdersUrl = "/account/orders",
	accountOrderUrl = "/account/order",

	accountAddressesUrl = "/account/addresses",
	accountAddressUrl = "/account/address",
	accountAddUpdateAddressUrl = "/account/addUpdateAddress",
	accountRemoveAddressUrl = "/account/removeAddress",

	-- checkout --
	cartUrl = "/cart",
	addToCartUrl = "/cart/add",
	updateProductEntryUrl = "/cart/update",

	checkoutUrl = "/checkout",

	checkoutReviewOrderUrl = "/checkout/reviewOrder",
	checkoutPlaceOrderUrl = "/checkout/placeOrder",

	checkoutConfirmationUrl = "/checkout/confirmation",

	checkoutAddressesUrl = "/checkout/addresses",
	checkoutAddressUrl = "/checkout/address",
	checkoutAddAddressUrl = "/checkout/addAddress",
	checkoutSetAddressUrl = "/checkout/setAddress",

	checkoutDeliveryMethodUrl = "/checkout/deliveryMethod",
	checkoutSetDeliveryMethodUrl = "/checkout/setDeliveryMethod",

	checkoutPaymentMethodUrl = "/checkout/paymentMethod",
	checkoutSetPaymentMethodUrl = "/checkout/setPaymentMethod",


	-- picture sizes --
	pictureWidth = "300px",
	pictureHeight = "400px",
	thumbnailPictureWidth = "46px",
	thumbnailPictureHeight = "62px",
}

config.localization = {
	homeMessage = {en = "Home", bg = "Начало"},
	accountMessage = {en = "Account", bg = "Профил"},
	cartMessage = {en = "Cart", bg = "Кошница"},
	checkoutMessage = {en = "Checkout", bg = "Поръчай"},
	clickToClose = {en = "click to close", bg = "натисни за да го скриеш"},
	edit = {en = "Edit", bg = "Редактирай"},
	cancel = {en = "Cancel", bg = "Откажи"},
	editAddress = {en = "Edit Address", bg = "Редактирай Адрес"},
	updateAddress = {en = "Update Address", bg = "Промени Адрес"},
	addAddress = {en = "Add Address", bg = "Добави Адрес"},
	removeAddress = {en = "Remove Address", bg = "Премахни Адрес"},
	setAddress = {en = "Set Addres", bg = "Избери Адрес"},
	viewOrder = {en = "Veiw Order", bg = "Прегледай Поръчка"},
	placeOrder = {en = "Place Order", bg = "Направи Поръчка"},
	continue = {en = "Continue", bg = "Продължи"},
	addToCart = {en = "Add To Cart", bg = "Добави В Кошницата"},
}

config.locations = {
	-- test controllers --
	{name = property.shopUrl .. property.testUrl .. "/controllers", script = "controllers/test/TestControllersController.lua"},
	{name = property.shopUrl .. property.testUrl .. "/modules", script = "controllers/test/TestModulesController.lua"},

	-- home --
	{name = property.shopUrl .. property.shopHomeUrl, script = "controllers/HomePageController.lua"},
	{name = property.shopUrl .. property.changeCountryUrl, script = "controllers/ChangeCountryController.lua"},

	-- catalog --
	{name = property.shopUrl .. property.productUrl, script = "controllers/catalog/ProductPageController.lua"},
	{name = property.shopUrl .. property.categoryUrl, script = "controllers/catalog/CategoryPageController.lua"},

	-- account --
	{name = property.shopUrl .. property.accountUrl, script = "controllers/account/AccountPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.loginUrl, script = "controllers/account/LoginPageController.lua"},
	{name = property.shopUrl .. property.registerUrl, script = "controllers/account/RegisterPageController.lua"},

	{name = property.shopUrl .. property.accountOrdersUrl, script = "controllers/account/AccountOrdersPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountOrderUrl, script = "controllers/account/AccountOrderPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.accountAddressesUrl, script = "controllers/account/AccountAddressesPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountAddressUrl, script = "controllers/account/AccountAddressPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountAddUpdateAddressUrl, requestBody = true, script = "controllers/account/AccountAddUpdateAddressController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountRemoveAddressUrl, script = "controllers/account/AccountRemoveAddressController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	-- checkout --
	{name = property.shopUrl .. property.cartUrl, script = "controllers/checkout/CartPageController.lua"},
	{name = property.shopUrl .. property.addToCartUrl, script = "controllers/checkout/AddToCartController.lua"},
	{name = property.shopUrl .. property.updateProductEntryUrl, script = "controllers/checkout/UpdateProductEntryController.lua"},

	{name = property.shopUrl .. property.checkoutUrl, script = "controllers/checkout/CheckoutPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutReviewOrderUrl, script = "controllers/checkout/CheckoutReviewOrderPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutPlaceOrderUrl, script = "controllers/checkout/CheckoutPlaceOrderController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutConfirmationUrl, script = "controllers/checkout/CheckoutConfirmationPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutAddressesUrl, script = "controllers/checkout/CheckoutAddressesPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutAddressUrl, script = "controllers/checkout/CheckoutAddressPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutAddAddressUrl, requestBody = true, script = "controllers/checkout/CheckoutAddAddressController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutSetAddressUrl, script = "controllers/checkout/CheckoutSetAddressController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutDeliveryMethodUrl, script = "controllers/checkout/CheckoutDeliveryMethodPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutSetDeliveryMethodUrl, script = "controllers/checkout/CheckoutSetDeliveryMethodController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutPaymentMethodUrl, script = "controllers/checkout/CheckoutPaymentMethodPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutSetPaymentMethodUrl, script = "controllers/checkout/CheckoutSetPaymentMethodController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},
}

config.access = {
	{name = "ShopRedirectOnSessionTimeoutFilter", script = "filter/ShopRedirectOnSessionTimeoutFilter.lua"},
	{name = "ShopThrowErrorOnSessionTimeoutFilter", script = "filter/ShopThrowErrorOnSessionTimeoutFilter.lua"},
}

config.javascripts = {
	-- header --
	{name = "Background", script = "widgets/header/Background.js"},
	{name = "Logo", script = "widgets/header/Logo.js"},
	{name = "CallUs", script = "widgets/header/CallUs.js"},
	{name = "Search", script = "widgets/header/Search.js"},
	{name = "MiniCart", script = "widgets/header/MiniCart.js"},
	{name = "ShopHeader", script = "widgets/header/ShopHeader.js"},
	{name = "Error", script = "widgets/header/Error.js"},

	-- catalog --
	{name = "HorizontalNavigation", script = "widgets/catalog/HorizontalNavigation.js"},
	{name = "ProductsGrid", script = "widgets/catalog/ProductsGrid.js"},
	{name = "ProductAttributeFilter", script = "widgets/catalog/ProductAttributeFilter.js"},
	{name = "ProductDetail", script = "widgets/catalog/ProductDetail.js"},

	-- account --
	{name = "RegisterForm", script = "widgets/account/RegisterForm.js"},
	{name = "AccountOptions", script = "widgets/account/AccountOptions.js"},
	{name = "Orders", script = "widgets/account/Orders.js"},
	{name = "Order", script = "widgets/account/Order.js"},
	{name = "Addresses", script = "widgets/account/Addresses.js"},
	{name = "AddressForm", script = "widgets/account/AddressForm.js"},

	-- checkout --
	{name = "Cart", script = "widgets/checkout/Cart.js"},
	{name = "DeliveryMethodForm", script = "widgets/checkout/DeliveryMethodForm.js"},
	{name = "PaymentMethodForm", script = "widgets/checkout/PaymentMethodForm.js"},
}

config.stylesheets = {
	-- header --
	--{name = "RegBackgroundWithPicture", script = "widgets/header/RegBackgroundWithPicture.css"}

	-- catalog --
	{name = "HorizontalNavigation", script = "widgets/catalog/HorizontalNavigation.css"},

	-- account --

	-- checkout --
	{name = "Cart", script = "widgets/checkout/Cart.css"},
}

config.modules = {
	-- import --
	{name = "shopImport", script = "import.lua"},

	-- services --
	{name = "countryService", script = "modules/CountryService.lua"},
	{name = "localeService", script = "modules/LocaleService.lua"},
	{name = "priceService", script = "modules/PriceService.lua"},
	{name = "cartService", script = "modules/CartService.lua"},

	-- exception --
	{name = "exceptionHandler", script = "modules/ExceptionHandler.lua"},
}

config.static = {
	"static"
}

config.types = {
	"types.lua"
}

config.tests = {
	{name = "testshop", script = "tests.js"}
}

return config -- return extension configuration