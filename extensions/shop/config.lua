local config = {} -- extension configuration

config.frontend = {
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

config.property = {
	-- security --
	shopRequireSecurity = true,
	
	-- country & locale --
	defaultCountryIsocode = "GB",
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

config.location = {
	-- home --
	{name = property.shopUrl .. property.shopHomeUrl, script = "controller/HomePageController.lua"},
	{name = property.shopUrl .. property.changeCountryUrl, script = "controller/ChangeCountryController.lua"},

	-- catalog --
	{name = property.shopUrl .. property.productUrl, script = "controller/catalog/ProductPageController.lua"},
	{name = property.shopUrl .. property.categoryUrl, script = "controller/catalog/CategoryPageController.lua"},

	-- account --
	{name = property.shopUrl .. property.accountUrl, script = "controller/account/AccountPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.loginUrl, script = "controller/account/LoginPageController.lua"},
	{name = property.shopUrl .. property.registerUrl, script = "controller/account/RegisterPageController.lua"},

	{name = property.shopUrl .. property.accountOrdersUrl, script = "controller/account/AccountOrdersPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountOrderUrl, script = "controller/account/AccountOrderPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.accountAddressesUrl, script = "controller/account/AccountAddressesPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountAddressUrl, script = "controller/account/AccountAddressPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountAddUpdateAddressUrl, script = "controller/account/AccountAddUpdateAddressController.lua", requestBody = true, access = "ShopThrowErrorOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.accountRemoveAddressUrl, script = "controller/account/AccountRemoveAddressController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	-- checkout --
	{name = property.shopUrl .. property.cartUrl, script = "controller/checkout/CartPageController.lua"},
	{name = property.shopUrl .. property.addToCartUrl, script = "controller/checkout/AddToCartController.lua"},
	{name = property.shopUrl .. property.updateProductEntryUrl, script = "controller/checkout/UpdateProductEntryController.lua"},

	{name = property.shopUrl .. property.checkoutUrl, script = "controller/checkout/CheckoutPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutReviewOrderUrl, script = "controller/checkout/CheckoutReviewOrderPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutPlaceOrderUrl, script = "controller/checkout/CheckoutPlaceOrderController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutConfirmationUrl, script = "controller/checkout/CheckoutConfirmationPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutAddressesUrl, script = "controller/checkout/CheckoutAddressesPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutAddressUrl, script = "controller/checkout/CheckoutAddressPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutAddAddressUrl, script = "controller/checkout/CheckoutAddAddressController.lua", requestBody = true, access = "ShopThrowErrorOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutSetAddressUrl, script = "controller/checkout/CheckoutSetAddressController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutDeliveryMethodUrl, script = "controller/checkout/CheckoutDeliveryMethodPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutSetDeliveryMethodUrl, script = "controller/checkout/CheckoutSetDeliveryMethodController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},

	{name = property.shopUrl .. property.checkoutPaymentMethodUrl, script = "controller/checkout/CheckoutPaymentMethodPageController.lua", access = "ShopRedirectOnSessionTimeoutFilter"},
	{name = property.shopUrl .. property.checkoutSetPaymentMethodUrl, script = "controller/checkout/CheckoutSetPaymentMethodController.lua", access = "ShopThrowErrorOnSessionTimeoutFilter"},
}

config.access = {
	{name = "ShopRedirectOnSessionTimeoutFilter", script = "filter/ShopRedirectOnSessionTimeoutFilter.lua"},
	{name = "ShopThrowErrorOnSessionTimeoutFilter", script = "filter/ShopThrowErrorOnSessionTimeoutFilter.lua"},
}

config.javascript = {
	-- header --
	{name = "Background", script = "widget/header/Background.js"},
	{name = "Logo", script = "widget/header/Logo.js"},
	{name = "CallUs", script = "widget/header/CallUs.js"},
	{name = "Search", script = "widget/header/Search.js"},
	{name = "MiniCart", script = "widget/header/MiniCart.js"},
	{name = "ShopHeader", script = "widget/header/ShopHeader.js"},
	{name = "Error", script = "widget/header/Error.js"},

	-- catalog --
	{name = "HorizontalNavigation", script = "widget/catalog/HorizontalNavigation.js"},
	{name = "ProductsGrid", script = "widget/catalog/ProductsGrid.js"},
	{name = "ProductAttributeFilter", script = "widget/catalog/ProductAttributeFilter.js"},
	{name = "ProductDetail", script = "widget/catalog/ProductDetail.js"},

	-- account --
	{name = "RegisterForm", script = "widget/account/RegisterForm.js"},
	{name = "AccountOptions", script = "widget/account/AccountOptions.js"},
	{name = "Orders", script = "widget/account/Orders.js"},
	{name = "Order", script = "widget/account/Order.js"},
	{name = "Addresses", script = "widget/account/Addresses.js"},
	{name = "AddressForm", script = "widget/account/AddressForm.js"},

	-- checkout --
	{name = "Cart", script = "widget/checkout/Cart.js"},
	{name = "DeliveryMethodForm", script = "widget/checkout/DeliveryMethodForm.js"},
	{name = "PaymentMethodForm", script = "widget/checkout/PaymentMethodForm.js"},
}

config.stylesheet = {
	-- header --
	--{name = "RegBackgroundWithPicture", script = "widget/header/RegBackgroundWithPicture.css"}

	-- catalog --
	{name = "HorizontalNavigation", script = "widget/catalog/HorizontalNavigation.css"},

	-- account --

	-- checkout --
	{name = "Cart", script = "widget/checkout/Cart.css"},
}

config.module = {
	-- import --
	{name = "shopImport", script = "import.lua"},

	-- services --
	{name = "countryService", script = "module/CountryService.lua"},
	{name = "localeService", script = "module/LocaleService.lua"},
	{name = "priceService", script = "module/PriceService.lua"},
	{name = "cartService", script = "module/CartService.lua"},

	-- exception --
	{name = "exceptionHandler", script = "module/ExceptionHandler.lua"},
}

config.static = {
	"static"
}

config.type = {
	"types.lua"
}

return config -- return extension configuration