local exception = require "exception"
local userService = require "userService"
local countryService = require "countryService"



local function currencyToCurrencyRate (from ,to)
	if from == "BGN" and to == "EUR" then
		return 0.51
	elseif from == "BGN" and to == "GBP" then
		return 0.37
	elseif from == "EUR" and to == "BGN" then
		return 1.95
	elseif from == "GBP" and to == "BGN" then
		return 2.73
	else
		exception(from .. " to " .. to .. " is not mapped")
	end
end


local function isFormatted (price)
	return type(price) ~= "table"
end


local function formatPrice (priceValue, currency)
	local formattedPrice
	if currency.symbolBeforeAmount then
		formattedPrice = currency.symbol .. priceValue
	else
		formattedPrice = priceValue .. currency.symbol
	end
	return formattedPrice
end


--
-- NOTE: ngx.ctx.vatRate holds vatRate for the country
--
local function getVATRate (db, product, country)
	local op = db:operators()

	if product.vatRates then
		for i=1,#product.vatRates do
			if product.vatRates[i].countryIsocode == country.isocode then
				return product.vatRates[i].vatRate / 100
			end
		end
	end

	if ngx.ctx.vatRate then
		return ngx.ctx.vatRate
	end

	local vatRate = db:findOne({countryVATRate = {countryIsocode = op.equal(country.isocode), vatRateType = op.equal("standart")}})
	ngx.ctx.vatRate = vatRate.vatRate / 100
	return ngx.ctx.vatRate
end


local function calculatePrice (price, country, vatRate, netUser)
	if price and country and vatRate then
		local currency = country.currency

		local vat, value
		if price.net then
			vat = price.value * vatRate
			if netUser then
				value = price.value
			else
				value = price.value + vat
			end
		else
			vat = price.value * (1 - 1 / (1 + vatRate))
			if netUser then
				value = price.value / (1 + vatRate)
			else
				value = price.value
			end
		end

		if price.currencyIsocode == currency.isocode then
			return {
				net = netUser,		
				vat = vat,		
				value = value,		
				currency = currency,		
			}
		else
			local currencyRate = currencyToCurrencyRate(price.currencyIsocode, currency.isocode)
			return {
				net = netUser,		
				vat = vat * currencyRate,		
				value = value * currencyRate,		
				currency = currency,		
			}
		end
	end
end


local function convertPrice (price, country, vatRate, netUser)
	if price and country and vatRate then
		-- price is already converted and formatted
		if isFormatted(price) then return price end

		local currency = country.currency

		local calculatedPrice = calculatePrice(price, country, vatRate, netUser)
		return formatPrice(calculatedPrice.value, currency)
	end
end


local function convertCartTotalPrice (price, country)
	if price and country then
		-- price is already converted and formatted
		if isFormatted(price) then return price end

		local currency = country.currency

		if price.currencyIsocode == currency.isocode then
			return formatPrice(price.value, currency)
		else
			local currencyRate = currencyToCurrencyRate(price.currencyIsocode, currency.isocode)
			return formatPrice(price.value * currencyRate, currency)
		end
	end
end


local function convertSinglePrice (db, price)
	if price then
		-- price is already converted and formatted
		if isFormatted(price) then return price end

		local country = countryService.getCountry(db)

		local status, netUser = pcall(userService.loggedIn, db, {}, {"netUser"})
		if not status then netUser = false end

		local vatRate = getVATRate(db, {}, country) -- no product

		return convertPrice(price, country, vatRate, netUser)
	end
end


local function convertPrices (db, product, country, netUser)
	if product and product.prices and country then
		local vatRate = getVATRate(db, product, country)

		local newPrices = {}
		for i=1,#product.prices do
			newPrices[#newPrices + 1] = convertPrice(product.prices[i], country, vatRate, netUser)
		end
		return newPrices
	end
end


local function convertProductsPrices (db, products)
	local country = countryService.getCountry(db)

	local status, netUser = pcall(userService.loggedIn, db, {}, {"netUser"})
	if not status then netUser = false end

	if products and country then
		if #products > 0 then
			for i=1,#products do
				products[i].prices = convertPrices(db, products[i], country, netUser)
			end
		else
			local product = products
			product.prices = convertPrices(db, product, country, netUser)
		end
	end
end


local function convertCartPrices (db, cart)
	local country = countryService.getCountry(db)

	local status, netUser = pcall(userService.loggedIn, db, {}, {"netUser"})
	if not status then netUser = false end

	if country and cart.productEntries then
		for i=1,#cart.productEntries do
			cart.productEntries[i].unitPrice = convertCartTotalPrice(cart.productEntries[i].unitPrice, country)
			cart.productEntries[i].totalPrice = convertCartTotalPrice(cart.productEntries[i].totalPrice, country)
		end

		cart.totalGrossPrice = convertCartTotalPrice(cart.totalGrossPrice, country)
		cart.totalNetPrice = convertCartTotalPrice(cart.totalNetPrice, country)
		cart.totalVAT = convertCartTotalPrice(cart.totalVAT, country)
	end
end


local function calculateProductPrice (db, product, price)
	if product and price then
		local country = countryService.getCountry(db)

		local status, netUser = pcall(userService.loggedIn, db, {}, {"netUser"})
		if not status then netUser = false end

		local vatRate = getVATRate(db, product, country)

		return calculatePrice(price, country, vatRate, netUser)
	end
end


return {
	currencyToCurrencyRate = currencyToCurrencyRate,
	isFormatted = isFormatted,
	formatPrice = formatPrice,
	calculatePrice = calculatePrice,
	convertPrice = convertPrice,
	convertPrices = convertPrices,
	convertProductsPrices = convertProductsPrices,
	convertCartPrices = convertCartPrices,
	convertSinglePrice = convertSinglePrice,
	calculateProductPrice = calculateProductPrice,
}