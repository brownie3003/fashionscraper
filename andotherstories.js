var request = require('request'),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var url = "http://www.stories.com/New_in";

function getProducts(url, callback) {
	request(url, function (error, response, body) {
		if (error) throw error;

		$ = cheerio.load(body);
		productList = $("#masonry a");
		// console.log(productList);

		var productLinks = [];

		productList.each(function() {
			productLinks.push("http://www.stories.com" + $(this).attr("href"));
		})

		//console.log(productLinks);
		callback(productLinks);
	});
};

getProducts(url, function (productLinks) { 
	for(link in productLinks) {

		request(productLinks[link], (function(link) {
			return function (error, response, body) {
				if (error) throw error;
				
				$_ = cheerio.load(body);

				var title = $_("#content > .page h1").text().split(/\r?\n/)[0]

				var imageUrl = "http://www.stories.com" + $_(".product-gallery img").attr('src');

				//console.log(imageUrl);

				// if (imageUrl.substring(0,2) == "//") {
				// 	imageUrl = "http:" + imageUrl;
				// };

				var type = title.split(" ").pop();

				var brand = "& other Stories";

				var shop = "& other Stories";

				var price = $_(".product-selection .price").text()

				var item = {
					"title": title, 
					"url": link,
					"price": price,
					"brand": brand,
					"shop": shop,
					"type": type,
					"imageUrl": imageUrl,
					"collectionDate" : new Date().toDateString()
				};				

				db.collection('products').find({url: link}).toArray(function (err, result) {
					if (err) throw err;
					if (result.length == 0) {
						db.collection('products').insert(item, function (err, result) {
							if (err) throw err;
							console.log("Inserted item " + title)
						});
					}
				});

				//console.log(item);
			}
		})(productLinks[link]));
	}
});