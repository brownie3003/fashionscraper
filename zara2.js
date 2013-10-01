var request = require('request'),
	cheerio = require('cheerio');

var url = "http://www.zara.com/uk/en/new-this-week/woman-c287002.html";

var getNewProducts = request(url, function(err, resp, body) {
	if (err)
		throw err;
	$ = cheerio.load(body);
	// console.log(body);
	var productList = $("#products").find("li").find(".product-info").find("a");
	var productLinks = [];
	
	productList.each(function () {
		productLinks.push($(this).attr("href"));
	});

	// console.log(productLinks);
});

var test = function(getNewProducts) {
	console.log(productLinks);
}

console.log(test)