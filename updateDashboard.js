/* Module that makes the dashboard */

var db = require('mongoskin').db("mongodb://weave:weave2013@paulo.mongohq.com:10000/weave-dev"),
	async = require('async'),
	sugar = require('sugar');
	//chrono = require('chrono-node');

	var day = new Date().toDateString()
	var shopArray = [];
	//var dayArray = [];
	var DashboardData = {};
	var data;

	// Create 14 day array to get data for past 14 days
	// var i = 1
	// var day1 = chrono.parse("14 days ago")[0].startDate;
	// dayArray.push(day1.toDateString());

	// for (i = 1; i < 14; i++) {
	// 	nextDay = new Date()
	// 	nextDay.setDate(day1.getDate() + i);
	// 	dayArray.push(nextDay.toDateString());
	// }

	//console.log(dayArray);
	
async.series([
	function (callback) {
		// Get all the fucking products which we call data (I should be wanking right now)
		console.log("In the first async operation");
		db.collection('products').find().toArray(function (err, result) {
			if (err) throw err;
	
			data = result;

			console.log(data.length);
			console.log("end of first async op (should come immediately)")
			callback();
		});
	},
	function (callback) {
		db.collection('product-dashboard').find().toArray(function (err, result) {
			console.log("get the object");
			if (err) throw err;

			dashboardData = result[0];

			console.log(dashboardData)
			console.log("Got that object")
			callback();
		})
	},
	function (callback) {
		//Dynamically create shop Array, it depends on what Shops/brands we are scraping
		console.log("in the second async")
		data.each(function (product) {
			// Add a new shop from data iteration if it isn't already in shopArray
			if (shopArray.indexOf(product.shop) == -1) {
				shopArray.push(product.shop)
			}
		});
		console.log(shopArray);
		console.log("At the end of second callback")
		callback();
	},
	function (callback) {
		console.log("in the third async")
		shopArray.each(function (shop) {
			dashboardData[shop][day] = 0;
			data.each(function (product) {
				// If we get a product from the correct shop and day that we are iterating over... stick it into the dashboardData
				if (product.shop == shop && product.collectionDate == day) {
					dashboardData[shop][day] = dashboardData[shop][day] + 1;
				}
			});
		});
		console.log(dashboardData)
		db.collection('product-dashboard').remove();
		callback();
	}
],
function (err) {
	if (err) return next(err);
	db.collection("product-dashboard").insert(dashboardData)
	console.log("finished")
});