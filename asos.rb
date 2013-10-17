require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'json'
require './categorize'

agent = Mechanize.new

agent.get("http://www.asos.com/Women/New-In-Clothing/Cat/pgecategory.aspx?cid=2623&via=top")

category = agent.page.search("#ctl00_ContentMainPage_ctlCategoryRefine_rptRefine_ctl00_PnlItemListWrapper .enabled")

category_links = Array.new

category_titles = Array.new

category.each do |element|
	link = agent.page.link_with(text: element.text).href
	category_links << "http://www.asos.com" + link
	title = element.text
	category_titles << title
end

categories_hash = Hash.new
categories_hash = Hash[category_titles.zip(category_links)]

agent.get("http://www.asos.com/Women/New-In-Shoes-Accs/Cat/pgecategory.aspx?cid=6992&via=top")

categories_hash["Shoes"] = "http://www.asos.com" + agent.page.link_with(text: "Shoes").href
categories_hash["Bags"] = "http://www.asos.com" + agent.page.link_with(text: "Bags & Purses").href

# puts categories_hash

categories_hash.each do |cat, link|
	puts cat
	agent.get(link)
	begin
		agent.page.link_with(text: "View all").click
	rescue
		puts "had to rescue"
	end

	products = agent.page.search("#items .desc").map(&:text)
	# puts link + " " + products.to_s

	product_links = Array.new

	products.each do |name|
		product_links << "http://www.asos.com" + agent.page.link_with(text: name).href
	end

	shop = "ASOS"

	product_links.each do |link|
		agent.get(link)

		title = agent.page.search("#ctl00_ContentMainPage_ctlSeparateProduct_lblProductTitle").text.strip

		image = agent.page.search("#ctl00_ContentMainPage_imgMainImage").attr("src")
		# puts image
		imageLinks = [image.value]

		i = 2
		image_exists = true

		until image_exists == false do
			new_image = image.value.gsub "image1", "image#{i}"
			new_image = new_image.gsub "/#{new_image.split("/")[-2]}", ""

			begin
				image_agent = Mechanize.new
				image_agent.get(new_image)
			rescue Exception => e
				image_exists = false
			end
			if image_exists == true
	 			imageLinks << new_image
	 		end
			i += 1
	 	end

		puts imageLinks

		category = agent.page.search("#ctl00_ContentMainPage_ctlSeparateProduct_divInvLongDescription a:nth-child(1) strong").text

		brand = agent.page.search("#ctl00_ContentMainPage_ctlSeparateProduct_divInvLongDescription h2").text
		brand.slice! "ABOUT "

		price = agent.page.search("#ctl00_ContentMainPage_ctlSeparateProduct_lblProductPrice").text

		description_elements = agent.page.search("li.single-entry ul li")
		description = String.new

		description_elements.each do |element|
			description.concat("#{element.text} \n")
		end
		
		begin
			category, subCategory = categorize title
			if subCategory == nil && category == nil
				puts "ALERT =================================="
			end
		rescue Exception => e 
			puts e
		end

		puts title + ". Category: " + category.to_s + ". Subcategory: " + subCategory.to_s

		puts title + " by " + brand + ". It costs " + price

		item = {
			"title" => title,
			"url" => link,
			"images" => imageLinks,
			"price" => price,
			"shop" => shop,
			"brand" => brand,
			"category" => category,
			"subCategory" => subCategory,
			# "materials" => materials,
			"description" => description,
			"collectionDate" => Time.now.strftime("%a %b %d %Y")
		}

		puts item

		uri = "mongodb://andy:weave2013@paulo.mongohq.com:10000/weave-dev"

		client = Mongo::MongoClient.from_uri(uri)

		db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
		db = client.db(db_name)

		products = db.collection("products")

		# Note that the insert method can take either an array or a single dict.
		if products.find("url" => link).to_a.empty?
			if category != "undefined" && subCategory != "undefined"
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

		# puts "Item: " + title.to_s + " - Images located at: " +  imageLinks.to_s
	end
end