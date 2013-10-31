require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'json'
require './categorize'

agent = Mechanize.new

agent.get("http://www.hm.com/gb/subdepartment/LADIES?Nr=90001")


products = agent.page.search("#list-products a")

product_links = Array.new

products.each do |product|
	product_links << product.attr("href")
end

i = 2

until i == 10 do
	agent.page.link_with(text: "#{i}").click
	products = products = agent.page.search("#list-products a")
	products.each do |product|
		product_links << product.attr("href")
	end
	i += 1
end

product_links

shop = "H&M"

brand = "H&M"

product_links.each do |link|
	agent.get(link)

	title = agent.page.search("h1").text.strip.split("£")[0].split("\r")[0]

	# puts link
	# puts title

	price = "£" + agent.page.search("h1").text.strip.split("£")[1].to_s

	images = agent.page.search("#product-thumbs img")

	imageLinks = Array.new

	images.each do |image|
		large_image = image.attr("src").gsub "thumb", "large"
		imageLinks << "http:" + large_image
	end

	cat = agent.page.search(".breadcrumbs li:nth-last-child(2)").text.strip.split("\r")[0].rstrip

	begin
		# Method categorize must have a category.
		category, subCategory = categorize title, cat
		if subCategory == nil && category == nil
			puts "ALERT =================================="
		end
	rescue Exception => e 
		puts e
	end

	description = agent.page.search(".description p").text.strip.split("\r")[0]

	material = agent.page.search("span#text-information").text + " " + agent.page.search("span#text-careInstruction").text

	item = {
		"title" => title,
		"url" => link,
		"images" => imageLinks,
		"price" => price,
		"shop" => shop,
		"brand" => brand,
		"category" => category,
		"subCategory" => subCategory,
		"materials" => material,
		"description" => description,
		"collectionDate" => Time.now.strftime("%a %b %d %Y")
	}

	# puts item

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

	# puts title + ". Category: " + category.to_s + ". Subcategory: " + subCategory.to_s


	# puts imageUrls
	# puts title + " " + price
end

# £

	