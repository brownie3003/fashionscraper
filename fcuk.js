var request = require('request'),
	cheerio = require('cheerio'),
	db = require('mongoskin').db('weave:weave2013@ds047948.mongolab.com:47948/weave');

var categoryUrls = {}

var productUrls = {}

function getProducts(categoryUrls, callback) {
	for(category in categoryUrls) {
		
	}
}


request("http://www.frenchconnection.com/product/Woman+New+In/72ADR/Feline+Wonder+Blouse.htm", function (error, response, body) {
	if (error) throw error;

	var html = cheerio.load(body);

	title = html("h1").text().trim();

	imageUrl = html("a#main_image").attr("href");

	console.log(title + " lives at " + imageUrl);
});