require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "mongo"
require "json"
require './categorize'

agent = Mechanize.new

agent.get("http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing.jsp")

categories_hash = {
	"Dresses" => "http://shop.mango.com/GB/m/mango/new/dresses/?m=familia&v=32",
	"Skirts" => "http://shop.mango.com/GB/m/mango/new/skirts/?m=familia&v=20",
	"Tops" => "http://shop.mango.com/GB/m/mango/new/tops/?m=familia&v=18,318",
	"Trousers" => "http://shop.mango.com/GB/m/mango/new/trousers/?m=familia&v=26,326",
	"Shorts" => "http://shop.mango.com/GB/m/mango/new/shorts/?m=familia&v=22,322",
	"Jeans" => "http://shop.mango.com/GB/m/mango/new/jeans/?m=familia&v=28",
	"Jumpsuits" => "http://shop.mango.com/GB/m/mango/new/jumpsuits/?m=familia&v=34",
	"Cardigans & Jumpers" => "http://shop.mango.com/GB/m/mango/new/cardigans-and-sweaters/?m=familia&v=55",
	"Jumpers" => "http://shop.mango.com/GB/m/mango/new/sweatshirts/?m=familia&v=56",
	"Jackets" => "http://shop.mango.com/GB/m/mango/new/jackets/?m=familia&v=4,304",
	"Coats" => "http://shop.mango.com/GB/m/mango/new/coats/?m=familia&v=2",
	"Accessories" => "http://shop.mango.com/GB/m/mango/new/bags/?m=accesorio&v=40",
	"Shoes" => "http://shop.mango.com/GB/m/mango/new/shoes/?m=accesorio&v=42"
}

categories_hash.each do |cat, link|
	agent.get(link)
	# puts link

	products = agent.page.search(".product_name").map(&:text)

	product_links = Array.new

	products.each do |name|
		product_links << "http://shop.mango.com/" + agent.page.link_with(text: name).href
	end

	# puts product_links

	product_links.each do |link|
		agent.get(link)
		puts link

		title = agent.page.search(".nombreProducto")[0].text.strip.rstrip

		price = agent.page.search(".precioProducto").text.strip.rstrip

		description = agent.page.search(".panel_descripcion").text.strip.rstrip

		materials = agent.page.search(".composicion").text.strip.rstrip

		shop = "Mango"

		brand = "Mango"

		images = agent.page.search("#tableFoto")

		image_links = Array.new

		images.each do |element|
			image_src = element.attr("data-src").gsub("S3", "S9")
			image_links << image_src
		end

		begin
			# Method categorize must have a category.
			category, subCategory = categorize title, cat
			if subCategory == nil && category == nil
				puts "ALERT =================================="
			end
		rescue Exception => e 
			puts e
		end

		# puts title + ". Category: " + category.to_s + ". Subcategory: " + subCategory.to_s

		item = {
			"title" => title,
			"url" => link,
			"images" => image_links,
			"price" => price,
			"shop" => shop,
			"brand" => brand,
			"category" => category,
			"subCategory" => subCategory,
			"materials" => materials,
			"description" => description,
			"collectionDate" => Time.now.strftime("%a %b %d %Y")
		}

		uri = "mongodb://andy:weave2013@paulo.mongohq.com:10000/weave-dev"

		client = Mongo::MongoClient.from_uri(uri)

		db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
		db = client.db(db_name)

		products = db.collection("products")

		# Note that the insert method can take either an array or a single dict.
		if products.find("url" => link).to_a.empty?
			if category != nil
			# 	puts "Title: " + item["title"]
			# 	puts "URL: " + item["url"]
			# 	puts "Image Links: " + item["images"].to_s
			# 	puts "Shop: " + item["shop"]
			# 	puts "Brand: " + item["brand"]
			# 	puts "Category: " + item["category"]
			# 	puts "Subcategory: " + item["subCategory"].to_s
			# 	puts "Materials: " + item["materials"]
			# 	puts "Collection Date: " + item["collectionDate"]
			# 	print "Insert into database? (y/n):"
			# 	confirm = gets
			# 	confirm.chomp!
			# 	if confirm == "y" or confirm == "Y"
			# 		products.insert(item)
			# 		puts "Item inserted"
			# 	else
			# 		puts "You decided not to insert into the database, Also Nick is a dick."
			# 	end

				products.insert(item)
				puts title + " inserted"
			else
				puts "Did not insert " + title + " because the category or sub category are undefined. Check " + link
			end
		else
			puts title + " already exists in the database"
		end
	end
end
