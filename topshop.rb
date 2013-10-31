require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "mongo"
require "json"

categories_hash = {
	"dresses" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/dresses-playsuits-678",
	"shoes" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/shoes-679",
	"tops" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/tops-680",
	"knitwear" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/knitwear-681",
	"jackets_coats" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/jackets-coats-682",
	"trousers_shorts" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/trousers-shorts-683",
	"accessories" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/accessories-684",
	"lingerie_nightwear" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/lingerie-nightwear-686",
	"swimwear" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/swimwear-687",
	"skirts" => "http://www.topshop.com/en/tsuk/category/new-in-this-week-2169932/new-in-this-week-493/skirts-692"
}

agent = Mechanize.new

categories_hash.each do |cat, link|
	agent.get(link)

	products = agent.page.search(".product_description a").map(&:text)

	product_links = Array.new

	products.each do |name|
		product_links << agent.page.link_with(text: name).href
	end

	shop = "Topshop"

	brand = "Topshop"

	# puts productLinks

	product_links.each do |link|
		agent.get(link)

		title = agent.page.search("h1").text.strip

		materials = agent.page.search(".product_description").text.strip

		price = agent.page.search(".product_price span").text.strip


		case
		when (title.to_s.include? "PJ" or title.to_s.include? "Pyjamas" or title.to_s.include? "Pyjama")
			category = "Nightwear"
			subcategory = "Pyjamas"
		when (title.to_s.include? "Dress")
			category = "Dresses"
		when (title.to_s.include? "Jumpsuit")
			category = "Dresses"
			subCategory = "Playsuits"
		when (title.to_s.include? "Playsuit")
			category = "Dresses"
			subCategory = "Playsuits"
		when (title.to_s.include? "Tunic")
			category = "Dresses"
		when (title.to_s.include? "Heels" or title.to_s.include? "Heel" or title.to_s.include? "Courts")
			category = "Shoes"
			subCategory = "Heels"
		when (title.to_s.include? "Boots")
			category = "Shoes"
			subCategory = "Boots"
		when (title.to_s.include? "Sandals")
			category = "Shoes"
			subCategory = "Sandals"
		when (title.to_s.include? "Slippers")
			category = "Shoes"
			subCategory = "Flats"
		when (title.to_s.include? "Tee")
			category = "Tops"
			subCategory = "T-Shirts"
		when (title.to_s.include? "Top" or title.to_s.include? "Corset" or title.to_s.include? "Cami" or title.to_s.include? "Vest")
			category = "Tops"
		when (title.to_s.include? "Shirt")
			category = "Tops"
			subCategory = "Shirts"
		when (title.to_s.include? "Blouse")
			category = "Tops"
			subCategory = "Blouses"
		when (title.to_s.include? "Sweatshirt" or title.to_s.include? "Sweater")
			category = "Jumpers"
			subCategory = "Sweaters"
		when (title.to_s.include? "Jumper")
			category = "Jumpers"
		when (title.to_s.include? "Coat" or title.to_s.include? "Puffer")
			category = "Coats"
		when (title.to_s.include? "Jacket")
			category = "Coats"
			subCategory = "Jackets"
		when (title.to_s.include? "Blazer")
			category = "Coats"
			subCategory = "Blazers"
		when (title.to_s.include? "Trousers")
			category = "Trousers"
		when (title.to_s.include? "Joggers")
			category = "Trousers"
			subCategory = "Joggers"
		when (title.to_s.include? "Jeans")
			category = "Trousers"
			subCategory = "Jeans"
		when (title.to_s.include? "Hotpants")
			category = "Trousers"
			subCategory = "Shorts"
		when (title.to_s.include? "Shorts")
			category = "Trousers"
			subCategory = "Shorts"
		when (title.to_s.include? "Leggings")
			category = "Trousers"
			subCategory = "Leggings"
		when (title.to_s.include? "Bag" or title.to_s.include? "Hand Bag" or title.to_s.include? "Clutch")
			category = "Accessories"
			subCategory = "Bags"
		when (title.to_s.include? "Scarf")
			category = "Accessories"
			subCategory = "Scarves"
		when (title.to_s.include? "Snood")
			category = "Accessories"
			subCategory = "Scarves"
		when (title.to_s.include? "Beanie" or title.to_s.include? "Hat")
			category = "Accessories"
			subCategory = "Hats"
		when (title.to_s.include? "Onesie")
			category = "Nightwear"
			subCategory = "Onsies"
		when (title.to_s.include? "Ladypants")
			category = "Lingerie"
			subcategory = "Ladypants"
		when (title.to_s.include? "Bra")
			category = "Lingerie"
			subcategory = "Bras"
		when (title.to_s.include? "Skirt" or title.to_s.include? "Kilt")
		category = "Skirts"
		else
			category = nil
			subCategory = nil
		end

		# puts title.to_s + ", Category: " + category.to_s + ", Subcategory: " + subCategory.to_s

		images = agent.page.search(".product_view")
		imageLinks = Array.new

		images.each do |element|
			image_link = element.attr('href')
			imageLinks << image_link

			i = 2
			image_exists = true

			until image_exists == false do
				baseLink = image_link.slice(0..-10)
				begin
					image_agent = Mechanize.new
					image_agent.get(baseLink + "#{i}_large.jpg")
				rescue Exception => e
					image_exists = false
				end
				if image_exists == true
		 			imageLinks << baseLink + ("#{i}_large.jpg")
		 		end
				i += 1
		 	end
		end

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

		# puts "Item: " + title.to_s + " - Images located at: " +  imageLinks.to_s
	end
end