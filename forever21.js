var request = require('request'),
	cheerio = require('cheerio');
	//db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var url = "http://www.forever21.com/UK/Product/Category.aspx?br=f21&category=whatsnew_all"

function getProducts(url) {
	request(url, function (error, response, body) {
		if (!error) {
			$ = cheerio.load(body);

			//JQuery doesn't allow selectors to be used.
			console.log($)

			productList = $("#ctl00_MainContent_dlCategoryList img");
			// console.log(productList);

			var productLinks = [];

			productList.each(function() {
				productLinks.push($(this).attr("href"));
			})

			console.log(productLinks);
			//callback(productLinks);
		};
	});
};

getProducts(url);

// getProducts(url, function (productLinks) {
// 	for(link in productLinks) {

// 		request(productLinks[link], (function(link) {
// 			return function (error, response, body) {
// 				if (!error) {
// 					$_ = cheerio.load(body);
// 					var productName = $_("h1").text().replace(/\s+/g, ' ').split("£")[0].slice(1);
// 					var productImage = $_("#product-image").attr('src');
// 					var type = $_(".breadcrumbs li:nth-last-child(2)").text().split("/")[0].trim();
// 					var productPrice = $_("#text-price span").text()
// 					var item = {
// 						"shop" : "H&M",
// 						"brand" : "H&M",
// 						"url" : link,
// 						"imageUrl" : productImage,
// 						"title" : productName,
// 						"price" : productPrice,
// 						"type" : type, 
// 						"collectionDate" : new Date().toDateString()
// 					};
					

// 					db.collection('products').find({url: link}).toArray(function (err, result) {
// 						if (err) throw err;
// 						if (result.length == 0) {
// 							db.collection('products').insert(item, function (err, result) {
// 								if (err) throw err;
// 								console.log("Inserted item " + productName)
// 							});
// 						}
// 					});

// 					//console.log(item);
// 				}
// 			}
// 		})(productLinks[link]));

// 	}
// });