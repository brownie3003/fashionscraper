require 'mechanize'
require "mongo"
require "json"
require "chronic"

agent = Mechanize.new

agent.get("http://www.zara.com/uk/en/new-this-week/woman-c287002.html");

products = agent.page.search(".name").map(&:text)

# puts products

productLinks = Array.new

products.each do |name|
	productLinks.push(agent.page.link_with(text: "#{name}").href)
end

# puts productLinks

productLinks.each do |link|
	agent.get(link)
	title = agent.page.search("h1").text.strip
	
	images = agent.page.search(".media-wrap a")
	imageLinks = Array.new

	images.each do |element|
		if element.attr("href").to_s[0,2] == "//"
			imageLinks << "http:" + element.attr("href")
		end
	end

	begin
		price = "£" + agent.page.search(".price span").attr("data-price").value.split[0]
	rescue Exception => e
		puts "There was an error with page: " + link
	end
	
	shop = "Zara"
	
	brand = "Zara"

	case 
	when (title.to_s.include? "DRESS")
		category = "Dresses"
	when (title.to_s.include? "JUMPER")
		category = "Jumpers"
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
	when (title.to_s.include? "STOLE")
		category = "Accessories"
		subCategory = "Stoles"
	when (title.to_s.include? "SCARF")
		category = "Accessories"
		subCategory = "Scarves"
	when (title.to_s.include? "BRACELET")
		category = "Accessories"
		subCategory = "Jewellery"
	when (title.to_s.include? "NECKLACE")
		category = "Accessories"
		subCategory = "Jewellery"
	when (title.to_s.include? "BELT")
		category = "Accessories"
		subCategory = "Belts"
	when (title.to_s.include? "FOOTIES")
		category = "Accessories"
		subCategory = "Socks"
	when (title.to_s.include? "JEANS")
		category = "Trousers"
		subCategory = "Jeans"
	when (title.to_s.include? "TROUSERS")
		category = "Trousers"
	when (title.to_s.include? "LEGGINGS")
		category = "Trousers"
		subCategory = "Leggings"
	when (title.to_s.include? "MINAUDIÉRE")
		category = "Accessories"
		subCategory = "Minaudières"
	when (title.to_s.include? "SKIRT")
		category = "Skirts"
	when (title.to_s.include? "SKORT")
		category = "Skirts"
		subCategory = "Skorts"
	when (title.to_s.include? "BOOT")
		category = "Shoes"
		subCategory = "Boots"
	when (title.to_s.include? "SHOE")
		category = "Shoes"
	when (title.to_s.include? "MOCCASIN")
		category = "Shoes"
		subCategory = "Flats"
	when (title.to_s.include? "BALLERINA")
		category = "Shoes"
		subCategory = "Flats"
	when (title.to_s.include? "PLIMSOLLS")
		category = "Shoes"
		subCategory = "Flats"
	else
		category = nil
		subCategory = nil
	end

	materials = agent.page.search(".composition ul div p").text.strip.delete("\r").delete("\t")

	item = {
		"title" => title,
		"url" => link,
		"images" => imageLinks,
		"price" => price,
		"shop" => shop,
		"brand" => brand,
		"category" => category,
		"subCategory" => subCategory,
		"materials" => materials,
		"collectionDate" => Chronic.parse("next Friday").strftime("%a %b %d %Y")
		"addedDate" => Time.now.strftime("%a %b %d %Y")
	}

	# puts item["collectionDate"]

	uri = "mongodb://andy:weave2013@paulo.mongohq.com:10000/weave-dev"

	client = Mongo::MongoClient.from_uri(uri)

	db_name = uri[%r{/([^/\?]+)(\?|$)}, 1]
	db = client.db(db_name)

	products = db.collection("products")

	# Note that the insert method can take either an array or a single dict.
	if products.find("url" => link).to_a.empty?
		if category != nil
			products.insert(item)
			puts "inserted " + title
		else
			puts "Did not insert " + title + " because the category or sub category are undefined. Check " + link
		end
	else
		puts title + " already exists in the database"
	end
end