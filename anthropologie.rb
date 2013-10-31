require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "mongo"
require "json"
require './categorize'

agent = Mechanize.new

agent.get("http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing.jsp")

categories_hash = {
	"Dresses" => "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-dresses.jsp?&id=NEWARRIVALS-CLOTHING-DRESSES&itemCount=100",
	"Knitwear" => "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-knitwear.jsp?&id=NEWARRIVALS-CLOTHING-KNITWEAR&itemCount=100",
	"Coats & Jackets" => "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-coatsjackets.jsp?&id=NEWARRIVALS-CLOTHING-COATSJACKETS&itemCount=100",
	"Skirts" => "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-skirts.jsp?&id=NEWARRIVALS-CLOTHING-SKIRTS&itemCount=100",
	"Tops" => "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-tops.jsp?&id=NEWARRIVALS-CLOTHING-TOPS&itemCount=100",
	"Sleep & Lounge" => "http://www.anthropologie.eu/anthro/category/clothing/clothing-newarrivals-sleeplingerie.jsp?&id=CLOTHING-NEWARRIVALS-SLEEPLINGERIE&itemCount=100",
	"Jumpsuits" => "http://www.anthropologie.eu/anthro/category/new%20arrivals/clothing-newarrivals-jumpsuits.jsp?&id=CLOTHING-NEWARRIVALS-JUMPSUITS&itemCount=100",
	"Jeans & Trousers" => "http://www.anthropologie.eu/anthro/category/clothing/newarrivals-clothing-jeanstrousers.jsp?cm_sp=LEFTNAV-_-SUB_CATEGORY-_-JEANS_&_TROUSERS"
}

categories_hash.each do |cat, link|
	agent.get(link)

	products = agent.page.search(".item-description a").map(&:text)

	product_links = Array.new

	products.each do |name|
		product_links << "http://www.anthropologie.eu" + agent.page.link_with(text: name).href
	end

	product_links.each do |link|
		agent.get(link)
		#puts link

		title = agent.page.search(".productName").text.strip

		editors_note = agent.page.search(".notescontent").text

		brand = Array.new

		title_words = title.split(" ")

		title_words.each do |word|
			brand << editors_note.match(word).to_s
		end

		# delelte empty elements or any words that probably are just the name of the item and have been capitalized in the editors notes, like Dress.
		brand.delete_if {|x| x == "" or x == "Dress"}
		if brand.empty?
			brand = "Anthropologie"
		else
			brand = brand.join(" ")
		end

		title.gsub!(brand, "")
		title.strip!

		price = agent.page.search(".prodprice").text.strip

		next if price.empty?
		
		materials_nokogiri = agent.page.search(".detailscopy li")
		materials = Array.new

		materials_nokogiri.each do |element|
			materials << element.text
		end

		materials.slice!(-1)
		materials = materials.join(" ")

		shop = "Anthropologie"

		base_image = agent.page.search("ul#alternateviewlist li img").attr("src").value

		images = Array.new

		images << base_image

		hack_array = ["c", "m1", "m2"]

		hack_array.each do |element|
			image_exists = true
			begin
				image_agent = Mechanize.new
				image_agent.get(base_image.value.gsub("_b", "_#{element}"))
			rescue Exception => e
				image_exists = false
				# puts "Image does not exist at " + base_image.value.gsub("_b", "_#{element}").to_s
			end

			if image_exists == true 
				images << base_image.value.gsub("_b", "_#{element}")
				# puts "Image exists = " + base_image.value.gsub("_b", "_#{element}").to_s
			end
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

		#puts title + ". Category: " + category.to_s + ". Subcategory: " + subCategory.to_s

		item = {
			"title" => title,
			"url" => link,
			"images" => images,
			"price" => price,
			"shop" => shop,
			"brand" => brand,
			"category" => category,
			"subCategory" => subCategory,
			"materials" => materials,
			# "description" => description,
			"collectionDate" => Time.now.strftime("%a %b %d %Y")
		}

		#puts item

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