require 'rubygems'
require 'mechanize'
require 'open-uri'

agent = Mechanize.new

agent.get("http://www.zara.com/uk/");

agent.page.link_with(text: "\r\n\t\t\t              \t\tNew this week\r\n\t\t\t              \t").click

products = agent.page.search(".name").map(&:text)

# puts products

productLinks = []

products.each do |name|
	productLinks.push(agent.page.link_with(text: "#{name}").href)
end

# puts productLinks

productLinks.each do |link|
	agent.get("#{link}")
	title = agent.page.search("h1").text.strip
	
	images = agent.page.search(".media-wrap a")
	imageLinks = []

	images.each do |element|
		if element.attr("href").to_s[0,2] == "//"
			imageLinks << element.attr("href")
		end
	end

	i = 0
	imageUrls = Hash.new

	while i < imageLinks.length do
		imageLinks.each do |element|
			imageUrls["image#{i}"] = "http:" + element
			i +=1
		end
	end

	# "image" => imageUrls

	# How to get a certain image.
	#puts item["images"]["image1"]
	
	price = "£" + agent.page.search(".price span").attr("data-price").value.split[0]
	
	shop = "Zara"
	
	brand = "Zara"

	case 
	when (title.to_s.include? "DRESS")
		category = "Dresses"
	when (title.to_s.include? "SWEATER" or title.to_s.include? "SWEATSHIRT")
		category = "Jumpers"
		subCategory = "Sweaters"
	when (title.to_s.include? "CARDIGAN")
		category = "Jumpers"
		subCategory = "Cardigans"
	when (title.to_s.include? "COAT")
		category = "Coats"
	when (title.to_s.include? "BLAZER")
		category = "Coats"
		subCategory = "Blazers"
	when (title.to_s.include? "JACKET")
		category = "Coats"
		subCategory = "Jackets"
	when (title.to_s.include? "TOP")
		category = "Tops"
	when (title.to_s.include? "BLOUSE")
		category = "Tops"
		subCategory = "Blouses"
	when (title.to_s.include? "T-SHIRT")
		category = "Tops"
		subCategory = "T-Shirts"
	when (title.to_s.include? "SHIRT")
		category = "Tops"
		subCategory = "Shirts"
	when (title.to_s.include? "BAG")
		category = "Accessories"
		subCategory = "Bags"
	when (title.to_s.include? "SCARF")
		category = "Accessories"
		subCategory = "Scarves"
	when (title.to_s.include? "BRACELET")
		category = "Accessories"
		subCategory = "Jewellery"
	when (title.to_s.include? "PHONE COVER")
		category = "Accessories"
		subCategory = "Phone Cover"
	when (title.to_s.include? "JEANS")
		category = "Trousers"
		subCategory = "Jeans"
	when (title.to_s.include? "TROUSERS")
		category = "Trousers"
	when (title.to_s.include? "SKIRT")
		category = "Skirts"
	when (title.to_s.include? "BOOT")
		category = "Shoes"
		subCategory = "Boots"
	when (title.to_s.include? "SHOE")
		category = "Shoes"
	when (title.to_s.include? "BALLERINA")
		category = "Shoes"
		subCategory = "Flats"
	else
		category = "undefined"
		subCategory = "undefined"		
	end

	materials = agent.page.search(".composition ul div p").text.strip.delete("\r").delete("\t")
	#materials = Hash[*materials]


	item = {
		"title" => title,
		"url" => link,
		"images" => imageUrls,
		"price" => price,
		"shop" => shop,
		"brand" => brand,
		"category" => category,
		"subCategory" => subCategory,
		"materials" => materials,
		"collectionDate" => Date.new
	}

	puts item
end


# links.each do |link|
# 	agent.get
# 	agent.page.link_with(text: "#{link}").click

# 	title = agent.page.search("h1").map(&:text).map(&:strip)

# 	imageUrl = agent.page.search("#bigImage").attr("src")

# 	puts "The title #{title}, lives at #{imageUrl}"
# end

# links.each do |link|
# 	puts link
# 	agent.page.link_with(text: "#{link}").click
# 	puts agent.page
# end	