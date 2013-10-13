var request = require('request'),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave'),
	url = "http://www.newlook.com/shop/new-in/view-all_2030164";


function getProducts(url, callback) {
	request(url, function (error, response, body) {
		if (error) throw error;

		$ = cheerio.load(body);
		productList = $(".desc a");
		//console.log(productList);

		var productLinks = [];

		productList.each(function() {
			productLinks.push("http://www.newlook.com" + $(this).attr("href"));
		})

		//console.log(productLinks);
		callback(productLinks);
	});
}

getProducts(url, function (productLinks) {
	for(link in productLinks) {

		request(productLinks[link], (function(link) {
			return function (error, response, body) {
				if (error) throw error;

				$_ = cheerio.load(body);

				var title = $_('h1').text();

				var imageUrl = $_("#mainImage").attr("src");

				if (imageUrl.substring(0,2) == "//") {
					imageUrl = "http:" + imageUrl;
				};

				var type = $_('.current a').text();

				var brand = "New Look";

				var price = $_('.promovalue').text();

				var shop = "New Look";

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

				//console.log(item)	
			}
		})(productLinks[link]));
	};
});