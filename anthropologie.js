var request = require('request'),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var categoryUrls = {
	"Coats & Jackets" : "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-coatsjackets.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-COATS_&_JACKETS", 
	"Dresses" : "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-dresses.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-DRESSES", 
	"Jeans & Trousers" : "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-jeanstrousers.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-JEANS_&_TROUSERS",
	"Knitwear" : "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-knitwear.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-KNITWEAR",
	"Skirts" : "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-skirts.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-SKIRTS",
	"Tops" : "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-tops.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-TOPS"}

var productUrls = {
	"Coats & Jackets" : [],
	"Dresses" : [],
	"Jeans & Trousers" : [],
	"Knitwear" : [],
	"Skirts" : [],
	"Tops" : []
}

function getProducts(categoryUrls, callback) {
	for(category in categoryUrls) {
		var url = categoryUrls[category]
		//console.log(url);
		
		// do the funky request binding the key & value to each request
		request(url, ( function (category, url) {
			return function (error, response, body) {
				if (error) throw error;
				
				var html = cheerio.load(body);

				html(".item-description a").each(function(i, result) {
					productUrls[category].push("http://www.anthropologie.eu" + cheerio(result).attr("href"));
					//console.log(productUrls);
					//console.log(cheerio(result).attr("href"));
				});

				//console.log(category + ": " + url)
				callback(productUrls);

			}

		})(category, url));


	};
};

// the most embarrasing piece of coding NICK ANGElI have ever written
// because we can't figure out
// how to execute the callback after the productUrls variable is full.
var seen = 0;
getProducts(categoryUrls, function(productUrls) {
	seen++;
	if(seen == 6) {
		for(category in productUrls) {
			var productUrl = (productUrls[category])
			
			for (url in productUrl) {
				var url = (productUrl[url]);

				request(url,( function (category, link) {
					return function (error, response, body) {
						if (error) throw error;
						var html = cheerio.load(body);

						var title = html(".productName").text().trim();

						var type = category;

						var imageUrl = html("ul#alternateviewlist img").attr("src");

						var shop = "Anthropologie"

						var brand = "Anthropologie"

						var price = html(".prodprice span").text().trim();

						// console.log(category + ": " + title + " image lives at " + imageUrl + " costs: " + price);

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

						//console.log(item);

						db.collection('products').find({url: link}).toArray(function (err, result) {
							if (err) throw err;
							if (result.length == 0) {
								db.collection('products').insert(item, function (err, result) {
									if (err) throw err;
									console.log("Inserted item " + title)
								});
							}
						});
					};
				})(category, url));
			}
		};
	}
});





/*for (category in productCategories) {
	url = productCategories[category];
	request(url, ( function (category) {
		return function (error, response, body) {
			if (error) throw error;

			$ = cheerio.load(body);
			console.log(productCategories[category]);
		};
	})(link));
}
*/