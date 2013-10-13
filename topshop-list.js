var request = require('request').defaults({maxRedirects:1000}),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var url = "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493#pageSize=200&catalogId=33057&viewAllFlag=false&sort_field=Relevance&langId=-1&beginIndex=1&storeId=12556&parent_categoryId=208491&categoryId=277012&refinements=category~[208503|277012]";

function getProducts(url, callback) {
	var head = {};
		head.url = url;
		head.headers = {
			'User-Agent': 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; de-de) AppleWebKit/523.10.3 (KHTML, like Gecko) Version/3.0.4 Safari/523.10',
			'Host': 'www.topshop.com',
			'Accept-Charset': 'ISO-8859-1,UTF-8;q=0.7,*;q=0.7'
		};
	request(head, function (error, response, body) {
		if (error) throw error;
		
		$ = cheerio.load(body);
		//console.log($.html());
		productList = $(".product_description a");
		//console.log(productList);

		var productLinks = [];

		productList.each(function() {
			productLinks.push($(this).attr("href"));
		})

		//console.log(productLinks);
		callback(productLinks);
	});
};

getProducts(url, function (productLinks) {
	console.log(productLinks);
})


// get an intern to fix the event listener overload.

/*getProducts(url, function (productLinks) {
	var head = {};
		head.url = productLinks[0];
		head.headers = {
			'User-Agent': 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; de-de) AppleWebKit/523.10.3 (KHTML, like Gecko) Version/3.0.4 Safari/523.10',
			'Host': 'www.topshop.com',
			'Accept-Charset': 'ISO-8859-1,UTF-8;q=0.7,*;q=0.7'
		};
		head.timeout = 5000;

	request(head, function (error, response, body) {
		if (error) throw error;

		$_ = cheerio.load(body);

		var title = $_('h1').text();

		console.log(title);
	});

	for(link in productLinks) {
		var head = {};
		head.url = productLinks[link];
		head.headers = {
			'User-Agent': 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; de-de) AppleWebKit/523.10.3 (KHTML, like Gecko) Version/3.0.4 Safari/523.10',
			'Host': 'www.topshop.com',
			'Accept-Charset': 'ISO-8859-1,UTF-8;q=0.7,*;q=0.7'
		};

		//console.log(head.url);


		request(head, (function(link) {
			return function (error, response, body) {
				if (error) throw error;

				$_ = cheerio.load(body);

				var title = $_('h1').text();

				console.log(title);
			 	var imageUrl = $_('.product_view').attr("href");

			 	if (imageUrl.substring(0,2) == "//") {
			 		imageUrl = "http" + imageUrl;
			 	};

			 	var type = "Dress"

			 	var brand = $_('h1').text().split("BY")[1];
			 	if(brand == undefined) {
			 		brand = "Topshop";
			 	};

				var price = $_('.product_price span').text();

			 	var shop = "Topshop";

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
});*/