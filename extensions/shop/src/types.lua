return {
    
    
    -- general types --
    
    stringEntry = {
        content             =   "string"
    },

    localizedString = {
        content             =   {type = "string", length = 1000},
        locale              =   {type = "string", length = 2},
    },

    property = {
        code                =   {type = "string", unique = true},
        content             =   "string"
    },

    localization = {
        code                =   {type = "string", unique = true},
        content             =   {type = "string", length = 1000},
        locale              =   {type = "string", length = 2},
    },

    country = {
        isocode             =   {type = "string", length = 2, unique = true},
        flag                =   "string",
        currency            =   hasOne("currency", "countries"),
        locale              =   {type = "string", length = 2},
    },

    countryVATRate = {
        countryIsocode      =   {type = "string", length = 2},
        vatRate             =   "float",
        vatRateType         =   "string",
        products            =   hasMany("product", "vatRates")
    },

    currency = {
        isocode             =   {type = "string", length = 3, unique = true},
        symbol              =   "string",
        symbolBeforeAmount  =   "boolean",
        countries           =   hasMany("country", "currency")
    },

    price = {
        currencyIsocode     =   {type = "string", length = 3},
        value               =   "float",
        net                 =   "boolean"
    },

    state = {
        code                =   "string",
        description         =   "string",
    },

    
    -- user's data --
    
    user = {
        country             =   "country",
        currency            =   "currency",
        wishlists           =   hasMany("wishlist", "user"),
        comparisons         =   hasMany("comparison", "user"),
        reviews             =   hasMany("review", "user"),
        questions           =   hasMany("question", "user"),
        answers             =   hasMany("answer", "user"),
        carts               =   hasMany("cart", "user"),
        orders              =   hasMany("order", "user"),
        addresses           =   hasMany("address", "user"),
    },

    address = {
        firstName           =   "string",
        middleName          =   "string",
        lastName            =   "string",
        telephone           =   "string",
        email               =   "string",
        line1               =   "string",
        line2               =   "string",
        city                =   "string",
        postCode            =   "string",
        country             =   "string",
        user                =   hasOne("user", "addresses"),
        carts               =   hasMany("cart", "address"),
        orders              =   hasMany("order", "address"),
    },

    wishlist = {
        name                =   "string",
        products            =   hasMany("product", "wishlists"),
        user                =   hasOne("user", "wishlists")
    },

    comparison = {
        name                =   "string",
        products            =   hasMany("product", "comparisons"),
        user                =   hasOne("user", "comparisons")
    },

    review = {
        count               =   "integer",
        content             =   {type = "string", length = 400},
        product             =   hasOne("product", "reviews"),
        user                =   hasOne("user", "reviews")
    },

    question = {
        content             =   {type = "string", length = 400},
        product             =   hasOne("product", "questions"),
        user                =   hasOne("user", "questions"),
        answer              =   hasOne("answer", "question")
    },

    answer = {
        content             =   {type = "string", length = 400},
        question            =   hasOne("question", "answer"),
        user                =   hasOne("user", "answers"),
    },


    -- catalog, category, product, cart & order --
    
    catalog = {
        code                =   {type = "string", unique = true},
        categories          =   hasMany("category", "catalogs"),
        products            =   hasMany("product", "catalogs")
    },
    
    category = {
        code                =   {type = "string", unique = true},
        name                =   hasMany("localizedString"),
        description         =   hasMany("localizedString"),
        pictures            =   hasMany("stringEntry"),
        products            =   hasMany("product", "categories"),
        subcategories       =   hasMany("category", "supercategories"),
        supercategories     =   hasMany("category", "subcategories"),
        catalogs            =   hasMany("catalog", "categories")
    },

    product = {
        code                =   {type = "string", unique = true},
        name                =   hasMany("localizedString"),
        description         =   hasMany("localizedString"),
        prices              =   hasMany("price"),
        vatRates            =   hasMany("countryVATRate", "products"),
        attributes          =   hasMany("productAttributeValue", "products"),
        pictures            =   hasMany("stringEntry"),
        productEntries      =   hasMany("productEntry", "product"),
        reviews             =   hasMany("review", "product"),
        wishlists           =   hasMany("wishlist", "products"),
        comparisons         =   hasMany("comparison", "products"),
        questions           =   hasMany("question", "product"),
        categories          =   hasMany("category", "products"),
        catalogs            =   hasMany("catalog", "products")
    },

    productAttribute = {
        code                =   {type = "string", unique = true},
        name                =   hasMany("localizedString"),
        values              =   hasMany("productAttributeValue", "key")
    },

    productAttributeValue = {
        code                =   {type = "string", unique = true},
        name                =   hasMany("localizedString"),
        key                 =   hasOne("productAttribute", "values"),
        products            =   hasMany("product", "attributes")
    },

    productEntry = {
        quantity            =   "integer",
        product             =   hasOne("product", "productEntries"),
        unitPrice           =   "price",
        totalPrice          =   "price",
        cart                =   hasOne("cart", "productEntries"),
        order               =   hasOne("order", "productEntries")
    },

    cart = {
        code                =   {type = "string", unique = true},
        user                =   hasOne("user", "carts"),
        productEntries      =   hasMany("productEntry", "cart"),
        address             =   hasOne("address", "carts"),
        deliveryMethod      =   hasOne("deliveryMethod", "carts"),
        paymentMethod       =   hasOne("paymentMethod", "carts"),
        totalGrossPrice     =   "price",
        totalNetPrice       =   "price",
        totalVAT            =   "price",
        creationTime        =   "string",
        lastCalculationTime =   "integer"
    },
    
    order = {
        code                =   {type = "string", unique = true},
        user                =   hasOne("user", "orders"),
        productEntries      =   hasMany("productEntry", "order"),
        address             =   hasOne("address", "orders"),
        deliveryMethod      =   hasOne("deliveryMethod", "orders"),
        paymentMethod       =   hasOne("paymentMethod", "orders"),
        totalGrossPrice     =   "price",
        totalNetPrice       =   "price",
        totalVAT            =   "price",
        creationTime        =   "string"
    },

    deliveryMethod = {
        name                =   hasMany("localizedString"),
        description         =   hasMany("localizedString"),
        price               =   "price",
        carts               =   hasMany("cart", "deliveryMethod"),
        orders              =   hasMany("order", "deliveryMethod"),
    },

    paymentMethod = {
        name                =   hasMany("localizedString"),
        carts               =   hasMany("cart", "paymentMethod"),
        orders              =   hasMany("order", "paymentMethod"),
    },
}