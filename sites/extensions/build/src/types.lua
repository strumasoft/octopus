-- Persistent Data
local multiRefObjects = {

} -- multiRefObjects
local obj1 = {
	["stringEntry"] = {
		["id"] = {
			["type"] = "id";
		};
		["content"] = {
			["type"] = "string";
			["length"] = 255;
		};
	};
	["order.productEntries-productEntry.order"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["comparison.products-product.comparisons"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["catalog.products-product.catalogs"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["price-productEntry.unitPrice"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product.reviews-review.product"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["property"] = {
		["content"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["localizedString-paymentMethod.name"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["comparison"] = {
		["products"] = {
			["type"] = "product.comparisons";
			["has"] = "many";
		};
		["user"] = {
			["type"] = "user.comparisons";
			["has"] = "one";
		};
		["name"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["order.totalGrossPrice-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["cart.totalNetPrice-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["country-user.country"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["deliveryMethod.description-localizedString"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["category.pictures-stringEntry"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["state"] = {
		["id"] = {
			["type"] = "id";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["description"] = {
			["type"] = "string";
			["length"] = 255;
		};
	};
	["countryVATRate.products-product.vatRates"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["order.totalVAT-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["country.currency-currency.countries"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["answer.user-user.answers"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["category.description-localizedString"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product"] = {
		["catalogs"] = {
			["type"] = "catalog.products";
			["has"] = "many";
		};
		["pictures"] = {
			["type"] = "stringEntry";
			["has"] = "many";
		};
		["prices"] = {
			["type"] = "price";
			["has"] = "many";
		};
		["productEntries"] = {
			["type"] = "productEntry.product";
			["has"] = "many";
		};
		["questions"] = {
			["type"] = "question.product";
			["has"] = "many";
		};
		["wishlists"] = {
			["type"] = "wishlist.products";
			["has"] = "many";
		};
		["id"] = {
			["type"] = "id";
		};
		["reviews"] = {
			["type"] = "review.product";
			["has"] = "many";
		};
		["vatRates"] = {
			["type"] = "countryVATRate.products";
			["has"] = "many";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["categories"] = {
			["type"] = "category.products";
			["has"] = "many";
		};
		["attributes"] = {
			["type"] = "productAttributeValue.products";
			["has"] = "many";
		};
		["comparisons"] = {
			["type"] = "comparison.products";
			["has"] = "many";
		};
		["name"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
		["description"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
	};
	["deliveryMethod.price-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["country"] = {
		["isocode"] = {
			["type"] = "string";
			["length"] = 2;
			["unique"] = true;
		};
		["flag"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["currency"] = {
			["type"] = "currency.countries";
			["has"] = "one";
		};
		["locale"] = {
			["type"] = "string";
			["length"] = 2;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["localizedString"] = {
		["content"] = {
			["type"] = "string";
			["length"] = 1000;
		};
		["locale"] = {
			["type"] = "string";
			["length"] = 2;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["currency"] = {
		["isocode"] = {
			["type"] = "string";
			["length"] = 3;
			["unique"] = true;
		};
		["countries"] = {
			["type"] = "country.currency";
			["has"] = "many";
		};
		["id"] = {
			["type"] = "id";
		};
		["symbol"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["symbolBeforeAmount"] = {
			["type"] = "boolean";
		};
	};
	["user.wishlists-wishlist.user"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["cart.deliveryMethod-deliveryMethod.carts"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["comparison.user-user.comparisons"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["countryVATRate"] = {
		["products"] = {
			["type"] = "product.vatRates";
			["has"] = "many";
		};
		["vatRate"] = {
			["type"] = "float";
		};
		["vatRateType"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["id"] = {
			["type"] = "id";
		};
		["countryIsocode"] = {
			["type"] = "string";
			["length"] = 2;
		};
	};
	["_"] = {
		["rdbms"] = "postgres";
		["database"] = "demo";
		["compact"] = false;
		["user"] = "demo";
		["password"] = "demo";
		["host"] = "127.0.0.1";
		["port"] = 5432;
	};
	["cart"] = {
		["totalVAT"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["deliveryMethod"] = {
			["type"] = "deliveryMethod.carts";
			["has"] = "one";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["productEntries"] = {
			["type"] = "productEntry.cart";
			["has"] = "many";
		};
		["user"] = {
			["type"] = "user.carts";
			["has"] = "one";
		};
		["address"] = {
			["type"] = "address.carts";
			["has"] = "one";
		};
		["lastCalculationTime"] = {
			["type"] = "integer";
		};
		["id"] = {
			["type"] = "id";
		};
		["creationTime"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["paymentMethod"] = {
			["type"] = "paymentMethod.carts";
			["has"] = "one";
		};
		["totalGrossPrice"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["totalNetPrice"] = {
			["type"] = "price";
			["has"] = "one";
		};
	};
	["question"] = {
		["content"] = {
			["type"] = "string";
			["length"] = 400;
		};
		["answer"] = {
			["type"] = "answer.question";
			["has"] = "one";
		};
		["user"] = {
			["type"] = "user.questions";
			["has"] = "one";
		};
		["product"] = {
			["type"] = "product.questions";
			["has"] = "one";
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product.pictures-stringEntry"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["address.user-user.addresses"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["category"] = {
		["catalogs"] = {
			["type"] = "catalog.categories";
			["has"] = "many";
		};
		["pictures"] = {
			["type"] = "stringEntry";
			["has"] = "many";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["id"] = {
			["type"] = "id";
		};
		["products"] = {
			["type"] = "product.categories";
			["has"] = "many";
		};
		["supercategories"] = {
			["type"] = "category.subcategories";
			["has"] = "many";
		};
		["subcategories"] = {
			["type"] = "category.supercategories";
			["has"] = "many";
		};
		["name"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
		["description"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
	};
	["productEntry"] = {
		["order"] = {
			["type"] = "order.productEntries";
			["has"] = "one";
		};
		["totalPrice"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["cart"] = {
			["type"] = "cart.productEntries";
			["has"] = "one";
		};
		["quantity"] = {
			["type"] = "integer";
		};
		["product"] = {
			["type"] = "product.productEntries";
			["has"] = "one";
		};
		["unitPrice"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["order.user-user.orders"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["localizedString-productAttribute.name"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["cart.user-user.carts"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["productAttribute.values-productAttributeValue.key"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product.attributes-productAttributeValue.products"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["productAttribute"] = {
		["name"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
		["values"] = {
			["type"] = "productAttributeValue.key";
			["has"] = "many";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["price"] = {
		["net"] = {
			["type"] = "boolean";
		};
		["currencyIsocode"] = {
			["type"] = "string";
			["length"] = 3;
		};
		["id"] = {
			["type"] = "id";
		};
		["value"] = {
			["type"] = "float";
		};
	};
	["answer"] = {
		["user"] = {
			["type"] = "user.answers";
			["has"] = "one";
		};
		["question"] = {
			["type"] = "question.answer";
			["has"] = "one";
		};
		["content"] = {
			["type"] = "string";
			["length"] = 400;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["category.name-localizedString"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["userGroup"] = {
		["id"] = {
			["type"] = "id";
		};
		["permissions"] = {
			["type"] = "userPermission.groups";
			["has"] = "many";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["users"] = {
			["type"] = "user.groups";
			["has"] = "many";
		};
	};
	["localizedString-productAttributeValue.name"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["address"] = {
		["carts"] = {
			["type"] = "cart.address";
			["has"] = "many";
		};
		["city"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["lastName"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["telephone"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["line1"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["line2"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["id"] = {
			["type"] = "id";
		};
		["country"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["postCode"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["user"] = {
			["type"] = "user.addresses";
			["has"] = "one";
		};
		["orders"] = {
			["type"] = "order.address";
			["has"] = "many";
		};
		["email"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["middleName"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["firstName"] = {
			["type"] = "string";
			["length"] = 255;
		};
	};
	["cart.totalGrossPrice-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["category.subcategories-category.supercategories"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["cart.paymentMethod-paymentMethod.carts"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["cart.totalVAT-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product.questions-question.product"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["address.carts-cart.address"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["answer.question-question.answer"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["price-productEntry.totalPrice"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["price-product.prices"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["catalog"] = {
		["products"] = {
			["type"] = "product.catalogs";
			["has"] = "many";
		};
		["id"] = {
			["type"] = "id";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["categories"] = {
			["type"] = "category.catalogs";
			["has"] = "many";
		};
	};
	["review.user-user.reviews"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["order.paymentMethod-paymentMethod.orders"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["localizedString-product.name"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["deliveryMethod.orders-order.deliveryMethod"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product.productEntries-productEntry.product"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["product.wishlists-wishlist.products"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["userGroup.permissions-userPermission.groups"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["deliveryMethod"] = {
		["carts"] = {
			["type"] = "cart.deliveryMethod";
			["has"] = "many";
		};
		["price"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["id"] = {
			["type"] = "id";
		};
		["orders"] = {
			["type"] = "order.deliveryMethod";
			["has"] = "many";
		};
		["name"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
		["description"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
	};
	["localizedString-product.description"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["productAttributeValue"] = {
		["products"] = {
			["type"] = "product.attributes";
			["has"] = "many";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["id"] = {
			["type"] = "id";
		};
		["key"] = {
			["type"] = "productAttribute.values";
			["has"] = "one";
		};
		["name"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
	};
	["user.groups-userGroup.users"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["question.user-user.questions"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["wishlist"] = {
		["products"] = {
			["type"] = "product.wishlists";
			["has"] = "many";
		};
		["user"] = {
			["type"] = "user.wishlists";
			["has"] = "one";
		};
		["name"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["currency-user.currency"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["paymentMethod"] = {
		["carts"] = {
			["type"] = "cart.paymentMethod";
			["has"] = "many";
		};
		["orders"] = {
			["type"] = "order.paymentMethod";
			["has"] = "many";
		};
		["name"] = {
			["type"] = "localizedString";
			["has"] = "many";
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["user"] = {
		["carts"] = {
			["type"] = "cart.user";
			["has"] = "many";
		};
		["id"] = {
			["type"] = "id";
		};
		["groups"] = {
			["type"] = "userGroup.users";
			["has"] = "many";
		};
		["questions"] = {
			["type"] = "question.user";
			["has"] = "many";
		};
		["token"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["lastLoginTime"] = {
			["type"] = "integer";
		};
		["country"] = {
			["type"] = "country";
			["has"] = "one";
		};
		["answers"] = {
			["type"] = "answer.user";
			["has"] = "many";
		};
		["comparisons"] = {
			["type"] = "comparison.user";
			["has"] = "many";
		};
		["passwordHash"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["email"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["wishlists"] = {
			["type"] = "wishlist.user";
			["has"] = "many";
		};
		["reviews"] = {
			["type"] = "review.user";
			["has"] = "many";
		};
		["currency"] = {
			["type"] = "currency";
			["has"] = "one";
		};
		["passwordSalt"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["addresses"] = {
			["type"] = "address.user";
			["has"] = "many";
		};
		["orders"] = {
			["type"] = "order.user";
			["has"] = "many";
		};
		["lastFailedLoginTime"] = {
			["type"] = "integer";
		};
		["permissions"] = {
			["type"] = "userPermission.users";
			["has"] = "many";
		};
		["failedLoginAttempts"] = {
			["type"] = "integer";
		};
	};
	["category.products-product.categories"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["deliveryMethod.name-localizedString"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["order"] = {
		["totalVAT"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["deliveryMethod"] = {
			["type"] = "deliveryMethod.orders";
			["has"] = "one";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["productEntries"] = {
			["type"] = "productEntry.order";
			["has"] = "many";
		};
		["user"] = {
			["type"] = "user.orders";
			["has"] = "one";
		};
		["address"] = {
			["type"] = "address.orders";
			["has"] = "one";
		};
		["id"] = {
			["type"] = "id";
		};
		["creationTime"] = {
			["type"] = "string";
			["length"] = 255;
		};
		["paymentMethod"] = {
			["type"] = "paymentMethod.orders";
			["has"] = "one";
		};
		["totalGrossPrice"] = {
			["type"] = "price";
			["has"] = "one";
		};
		["totalNetPrice"] = {
			["type"] = "price";
			["has"] = "one";
		};
	};
	["userPermission"] = {
		["groups"] = {
			["type"] = "userGroup.permissions";
			["has"] = "many";
		};
		["id"] = {
			["type"] = "id";
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["users"] = {
			["type"] = "user.permissions";
			["has"] = "many";
		};
	};
	["catalog.categories-category.catalogs"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["localization"] = {
		["locale"] = {
			["type"] = "string";
			["length"] = 2;
		};
		["content"] = {
			["type"] = "string";
			["length"] = 1000;
		};
		["code"] = {
			["type"] = "string";
			["length"] = 255;
			["unique"] = true;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["address.orders-order.address"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["order.totalNetPrice-price"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["cart.productEntries-productEntry.cart"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
	["review"] = {
		["content"] = {
			["type"] = "string";
			["length"] = 400;
		};
		["id"] = {
			["type"] = "id";
		};
		["user"] = {
			["type"] = "user.reviews";
			["has"] = "one";
		};
		["product"] = {
			["type"] = "product.reviews";
			["has"] = "one";
		};
		["count"] = {
			["type"] = "integer";
		};
	};
	["user.permissions-userPermission.users"] = {
		["value"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["key"] = {
			["type"] = "string";
			["length"] = 36;
		};
		["id"] = {
			["type"] = "id";
		};
	};
}
return obj1
