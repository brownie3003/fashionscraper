var request = require('request'),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var url = "http://www.asos.com/Women/New-In-Clothing/Cat/pgecategory.aspx?cid=2623#parentID=-1&pge=0&pgeSize=204&sort=-1";

function getProducts(url, callback) {
	request(url, function (error, response, body) {
		if (!error) {
			$ = cheerio.load(body);
			//console.log($);
			productList = $(".desc");
			//console.log(productList);

			var productLinks = [];

			productList.each(function() {
				productLinks.push("http://www.asos.com" + $(this).attr("href"));
			})

			//console.log(productLinks);
			callback(productLinks);
		};
	});
};

getProducts(url, function (productLinks) {
	for(link in productLinks) {

		request(productLinks[link], (function(link) {
			return function (error, response, body) {
				if (error) throw error;

				$_ = cheerio.load(body);

				var title = $_('#ctl00_ContentMainPage_ctlSeparateProduct_lblProductTitle').text();

				var imageUrl = $_('#ctl00_ContentMainPage_imgMainImage').attr("src");

				var type = $_('#ctl00_ContentMainPage_ctlSeparateProduct_divInvLongDescription a:nth-child(1) strong').text();

				var brand = $_('a:nth-child(2) strong').text();

				var price = $_('#ctl00_ContentMainPage_ctlSeparateProduct_lblProductPrice').text();

				shop = "ASOS";

				var item = {
					"title": title, 
					"price": price,
					"brand": brand,
					"shop": shop,
					"type": type,
					"imageUrl": imageUrl
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


/*getProductst(url, function (productLinks) {
	if(err) throw err;
	
	var parsedHtml = $.load(html);

	var title, price, brand, shop, type, imageUrl;

	parsedHtml('#ctl00_ContentMainPage_ctlSeparateProduct_lblProductTitle').each(function(i, text) {
		title = $(text).text();
	});

	parsedHtml('#ctl00_ContentMainPage_ctlSeparateProduct_lblProductPrice').each(function(i, text) {
		price = $(text).text();
	});

	parsedHtml('a:nth-child(2) strong').each(function(i, text) {
		brand = $(text).text();
	});

	shop = "ASOS";

	parsedHtml('#ctl00_ContentMainPage_ctlSeparateProduct_divInvLongDescription a:nth-child(1) strong').each(function(i, text) {
		type = $(text).text();
	});

	parsedHtml('#ctl00_ContentMainPage_imgMainImage').each(function(i, text) {
		imageUrl = $(text).attr('src');
	});

	var data = {
		"title": title, 
		"price": price,
		"brand": brand,
		"shop": shop,
		"type": type,
		"imageUrl": imageUrl
	};
	callback(data);
});*/