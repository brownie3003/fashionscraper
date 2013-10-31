require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "mongo"
require "json"
require './categorize'
require 'chronic'

agent = Mechanize.new

agent.get("http://www.stories.com/")

categories_hash = {
	"Shoes" => "http://www.stories.com/New_in/Shoes",
	"Bags" => "http://www.stories.com/New_in/Bags",
	"Lingerie & Nightwear" => "http://www.stories.com/New_in/Lingerie",
	"Clothes" => "http://www.stories.com/New_in/Ready-to-wear",
}

categories_hash.each do |cat, link|
	agent.get(link)

	products = agent.page.search("#masonry a")

	product_links = Array.new

	products.each do |element|
		product_links << "http://www.stories.com" + element.attr("href")
	end

	product_links.each do |link|
		agent.get(link)
		puts link

		description = agent.page.search("#tab-1 p:nth-child(1)").text

		materials = agent.page.search("#tab-2 .paddingb-8").text.strip.rstrip

		if description.include? "& OTHER STORIES"
			brand = "& OTHER STORIES"
		else
			desc_split = description.split(" ")
			brand_array = Array.new
			desc_split.each do |word|
				if word.match(/\b\p{L}*\p{Lu}{3}\p{L}*\b/u)
					brand_array << word
			 	end
				brand = brand_array.join(" ")
			end
		end

		description.gsub!(/(#{brand})/i, "").strip!

		# puts description

		title = agent.page.search("h1").text.gsub("All new in", "").rstrip.gsub(/(#{brand})/i, "").strip.split("\r")[0]

		puts title

		price = agent.page.search(".product-selection .price").text

		shop = "& Other Stories"

		image_links = Array.new

		images = agent.page.search("ul.image-list li a img")

		images.each do |element|
			image_links << "http://www.stories.com" + agent.page.search("ul.image-list li a img").attr("src").value.gsub("_3_", "_2_")
		end

		# puts image_links

		begin
			# Method categorize must have a category.
			category, subCategory = categorize title, cat
			if subCategory == nil && category == nil
				puts "ALERT =================================="
			end
		rescue Exception => e 
			puts e
		end

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

		# puts item

		# uri = "mongodb://andy:weave2013@paulo.mongohq.com:10000/weave-dev"

		# client = Mongo::MongoClient.from_uri(uri)

		# db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
		# db = client.db(db_name)

		# products = db.collection("products")

		# # Note that the insert method can take either an array or a single dict.
		# if products.find("url" => link).to_a.empty?
		# 	if category != nil
		# 	# 	puts "Title: " + item["title"]
		# 	# 	puts "URL: " + item["url"]
		# 	# 	puts "Image Links: " + item["images"].to_s
		# 	# 	puts "Shop: " + item["shop"]
		# 	# 	puts "Brand: " + item["brand"]
		# 	# 	puts "Category: " + item["category"]
		# 	# 	puts "Subcategory: " + item["subCategory"].to_s
		# 	# 	puts "Materials: " + item["materials"]
		# 	# 	puts "Collection Date: " + item["collectionDate"]
		# 	# 	print "Insert into database? (y/n):"
		# 	# 	confirm = gets
		# 	# 	confirm.chomp!
		# 	# 	if confirm == "y" or confirm == "Y"
		# 	# 		products.insert(item)
		# 	# 		puts "Item inserted"
		# 	# 	else
		# 	# 		puts "You decided not to insert into the database, Also Nick is a dick."
		# 	# 	end

		# 		products.insert(item)
		# 		puts title + " inserted"
		# 	else
		# 		puts "Did not insert " + title + " because the category or sub category are undefined. Check " + link
		# 	end
		# else
		# 	puts title + " already exists in the database"
		# end

		#puts title + ". Category: " + category.to_s + ". Subcategory: " + subCategory.to_s
	end
end