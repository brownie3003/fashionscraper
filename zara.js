var request = require('request'),
	cheerio = require('cheerio');
	async = require('async');

var url = "http://www.zara.com/uk/en/new-this-week/woman-c287002.html",
	productLinks = [];


// This function will visit the new in page and get the links for all the new products
// We have a callback in this function that will execute once we have all the product links in an array.
function getProducts(url, callback) {
	request({url: url, jar: true}, function(err,resp,body) {
		if (err)
			throw err;
		$ = cheerio.load(body);
		// console.log(body);
		var productList = $("#products").find("li").find(".product-info").find("a");
		var productLinks = [];
		
		productList.each(function (i) {
			productLinks.push($(this).attr("href"));
		});
		
		//console.log(productLinks);

		// This is an example of a self executing function from http://blog.miguelgrinberg.com/post/easy-web-scraping-with-nodejs <<<---- READ IT

		// We declare a variable 
		// var theLink = "bitch"

		// The function is then writtent var myFunction = function(variable)
		// We replace function part with another function in brackets var myFunction = (...[new function]...) (variable i.e. theLink);

		// var callback = ( function(myVariable) {
		// 	return function() {
		// 		console.log(myVariable)
		// 	}
		// }) (theLink);

		// theLink = "cunt";

		callback(productLinks);
	});
}

getProducts(url, function(productLinks) {
	for(i=0; i < productLinks.length; i++) {
		(function(i) {
			setTimeout(function() {
				var productUrl = productLinks[i]
				console.log(productUrl);

				// We create a self executing with the productUrl variable passed in on each loop (the myLink variable).
				// By doing it this way we the link address for each iteration over the loop, otherwise we'd get the last link (I think? not sure tbh)
				request ({url: productUrl, jar: true}, (function(myLink) {
					return function(err, resp, body) {
						if (err)
							throw err;
						$_ = cheerio.load(body);
		
								var imageUrl =  $_(".image-big").attr('src');
								var productName = $_("h1").text().replace(/\s+/g, ' ').slice(1);
		
								if (imageUrl != undefined) {
									var productPrice = "£" + $_("span.price").attr("data-price").split(" ")[0];					
								}
		
								var item = {
									"productUrl" : myLink,
									"imageUrl" : imageUrl,
									"productName" : productName,
									"productPrice" : productPrice
								};
		
								console.log(item);
							}
				}) (productUrl));
				
			}, 1000 * i);
		}(i));
	}
});
	
	// 		console.log(productLinks)

			/*var productUrl = productLinks[link];

	

	/*for (link in productLinks) {
		
	};*/