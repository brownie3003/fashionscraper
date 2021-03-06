var request = require('request'),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var url = "http://www.hm.com/gb/subdepartment/LADIES?Nr=90001#pageSize=MORE&Nr=90001";

function getProducts(url, callback) {
	request(url, function (error, response, body) {
		if (error) throw error;

		$ = cheerio.load(body);
		productList = $("#list-products a");
		// console.log(productList);

		var productLinks = [];

		productList.each(function() {
			productLinks.push($(this).attr("href"));
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

				var title = $_("h1").text().replace(/\s+/g, ' ').split("£")[0].slice(1);

				var imageUrl = $_("#product-image").attr('src');

				if (imageUrl.substring(0,2) == "//") {
					imageUrl = "http:" + imageUrl;
				};

				var type = $_(".breadcrumbs li:nth-last-child(2)").text().split("/")[0].trim();

				var brand = "H&M";

				var shop = "H&M";

				var price = $_("#text-price span").text()

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

/*var google = "http://www.google.com";
request(google, function (error, response, body) {
  if (!error && response.statusCode == 200) {
    console.log(body) // Print the google web page.
  }
})*/