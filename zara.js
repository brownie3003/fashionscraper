var request = require('request'),
	cheerio = require('cheerio');
	async = require('async');

var url = "http://www.zara.com/uk/en/new-this-week/woman-c287002.html";

/*function getProducts(url) {
	request(url, function(err, resp, body) {
		if (err)
			throw err;
		$ = cheerio.load(body);
		// console.log(body);
		var productList = $("#products").find("li").find(".product-info").find("a");
		var productLinks = [];
		
		productList.each(function (i) {
			productLinks.push($(this).attr("href"));
		});
		console.log(productLinks);
		// callback(productLinks);

		request(link, function(err,resp, body))
	});
};*/

// getProducts(url, function(links) {
// 	console.log(links);
// 	async.forEach(links,function(link, callback) {
// 		getImages(link, function(cb){
// 			callback();
// 		}); 
// 	}, function(err) {
// 		if (err) 
// 			throw err;
// 		console.log("It fucking worked")
// 	});
// });

// function getImages(productPage, callback) {
// 	request(productPage, function(err,resp,body) {
// 		if (err)
// 			throw err
// 		$ = cheerio.load(body);
// 		var imageUrl =  $(".image-big").attr('src');
// 		console.log(imageUrl);
// 		callback();
// 	});
// };


request(url, function(err, resp, body) {
	if (err)
		throw err;
	$ = cheerio.load(body);
	// console.log(body);
	var productList = $("#products").find("li").find(".product-info").find("a");
	var productLinks = [];
	
	productList.each(function (i) {
		productLinks.push($(this).attr("href"));
	});


	// // console.log(productLinks);

	// // console.log(productLinks.length);

	for (link in productLinks) {
		var productUrl = productLinks[link];
		request(productUrl, (function(link) { return function(err, resp, body) {
			var $_ = cheerio.load(body);
			//console.log(productLinks[link]);



			// var imageUrl =  $_(".image-big").attr('src');
			var imageUrl = "";
			$_("#bigImage").each(function() {
				imageUrl = $(this).attr('src');
				console.log(imageUrl);
			});
			
			var productNumber = "";
			$_("#product").each(function() {
				productNumber = $(this).attr("class").split(/\s+/)[3].split("_")[1];
				// console.log(productNumber);
			});
	
			var productName = "";
			$_("#productRighMenu-" + productNumber + " h1").each(function() {
				productName = $(this).text()
				// console.log(productName);
			});
			
			
			var productPrice = "";
			$_("span.price").each(function() {
				productPrice = "£" + $(this).attr("data-price").split(" ")[0];
				// console.log(productPrice);
			});

			var item = {
				"imageUrl" : imageUrl,
				"productNumber" : productNumber,
				"productPrice" : productPrice
			};

			//console.log(item)

		}})(link));
	};
});

// request(url2, function(err, resp, body) {
// 	if (err)
// 		throw err;
// 	$ = cheerio.load(body);
// 	/*console.log(body);*/
// 	var imageUrl = $("#bigImage").attr('src');
// 	console.log("Image Url: " + imageUrl);
// 	var productNumber = $("#product").attr('class').split(/\s+/)[3].split("_")[1];
// 	console.log(productNumber);
// 	var productName = $("#productRightMenu-" + productNumber + " h1").text().replace(/\s+/g, ' ').slice(1);
// 	console.log(productName);
// 	var productPrice = "£" + $("span.price").attr("data-price").split(" ")[0];
// 	console.log(productPrice);
// });