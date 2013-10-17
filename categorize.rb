def categorize title
	item_title = title.downcase

	# The magical library catorgrising 
	case
	# ============= DRESSES =====================
	when (item_title.to_s.include? "maxi")
		category = "dresses"
		subCategory = 'maxi dresses'
	when (item_title.to_s.include? "jumpsuit")
		category = "dresses"
		subCategory = "playsuits"
	when (item_title.to_s.include? "bodycon")
		category = "dresses"
		subCategory = "bodycon dresses"
	when (item_title.to_s.include? "playsuit")
		category = "dresses"
		subCategory = "playsuits"
	when (item_title.to_s.include? "tunic")
		category = "dresses"
	when (item_title.to_s.include? "dress")
		category = "dresses"

	# ============= COATS =====================
	when (item_title.to_s.include? "parka")
		category = "coats"
		subCategory = "parkas"
	when (item_title.to_s.include? "gilet")
		category = "coats"
		subCategory = "gilets"
	when (item_title.to_s.include? "jacket")
		category = "coats"
		subCategory = "jackets"
	when (item_title.to_s.include? "blazer")
		category = "coats"
		subCategory = "blazers"
	when (item_title.to_s.include? "biker")
		category = "coats"
		subCategory = "biker jacket"
	when (item_title.to_s.include? "coat" or item_title.to_s.include? "puffer")
		category = "coats"

	# ============= SHOES =====================
	when (item_title.to_s.include? "heels" or item_title.to_s.include? "heel" or item_title.to_s.include? "courts")
		category = "shoes"
		subCategory = "heels"
	when (item_title.to_s.include? "boots")
		category = "shoes"
		subCategory = "boots"
	when (item_title.to_s.include? "sandals")
		category = "shoes"
		subCategory = "sandals"
	when (item_title.to_s.include? "slippers")
		category = "shoes"
		subCategory = "flats"
	when (item_title.to_s.include? "tee")
		category = "tops"
		subCategory = "t-shirts"
	when (item_title.to_s.include? "top" or item_title.to_s.include? "corset" or item_title.to_s.include? "cami" or item_title.to_s.include? "vest")
		category = "tops"
	when (item_title.to_s.include? "shirt")
		category = "tops"
		subCategory = "shirts"
	when (item_title.to_s.include? "blouse")
		category = "tops"
		subCategory = "blouses"
	
	# ============= JUMPERS =====================
	when (item_title.to_s.include? "sweatshirt" or item_title.to_s.include? "sweater")
		category = "jumpers"
		subCategory = "sweaters"
	when (item_title.to_s.include? "cardigan")
		category = "jumpers"
		subCategory = "cardigans"
	when (item_title.to_s.include? "jumper")
		category = "jumpers"
	
	when (item_title.to_s.include? "trousers" or item_title.to_s.include? "trouser")
		category = "trousers"
	when (item_title.to_s.include? "joggers")
		category = "trousers"
		subCategory = "joggers"
	when (item_title.to_s.include? "jeans" or item_title.to_s.include? "jean")
		category = "trousers"
		subCategory = "jeans"
	when (item_title.to_s.include? "hotpants")
		category = "trousers"
		subCategory = "shorts"
	when (item_title.to_s.include? "shorts" or item_title.to_s.include? "short")
		category = "trousers"
		subCategory = "shorts"
	when (item_title.to_s.include? "leggings" or item_title.to_s.include? "legging")
		category = "trousers"
		subCategory = "leggings"
	when (item_title.to_s.include? "bag" or item_title.to_s.include? "hand bag" or item_title.to_s.include? "clutch")
		category = "accessories"
		subCategory = "bags"
	when (item_title.to_s.include? "scarf")
		category = "accessories"
		subCategory = "scarves"
	when (item_title.to_s.include? "snood")
		category = "accessories"
		subCategory = "scarves"
	when (item_title.to_s.include? "beanie" or item_title.to_s.include? "hat")
		category = "accessories"
		subCategory = "hats"
	when (item_title.to_s.include? "pyjama") && (item_title.to_s.include? "trouser" or item_title.to_s.include? "trousers")
		category = "nightwear"
		subCategory = "pyjamas"
	when (item_title.to_s.include? "onesie")
		category = "nightwear"
		subCategory = "onsies"
	when (item_title.to_s.include? "ladypants")
		category = "lingerie"
		subCategory = "underwear"
	when (item_title.to_s.include? "pant" or item_title.to_s.include? "pants" or item_title.to_s.include? "boxer" or item_title.to_s.include? "bra" or item_title.to_s.include? "briefs" or item_title.to_s.include? "brief")
		category = "lingerie"
	when (item_title.to_s.include? "pj" or item_title.to_s.include? "pyjamas" or item_title.to_s.include? "pyjama")
		category = "nightwear"
		subCategory = "pyjamas"
	when (item_title.to_s.include? "hoody" or item_title.to_s.include? "hoodie")
		category = "jumpers"
		subCategory = "hoodie"
	when (item_title.to_s.include? "skirt" or item_title.to_s.include? "kilt")
		category = "skirts"
	
	# ============= SWIMWEAR =====================
	when (item_title.to_s.include? "bikini")
		category = "swimwear"
		subCategory = "bikinis"
	else
		category = nil
		subCategory = nil
	end
	if category != nil
		category.capitalize!
	end
	if subCategory != nil
		subCategory.capitalize!
	end

	return category, subCategory
end

# example of categorize usage
title = "Maxi Dress"

begin
	category, subCategory = categorize title
	if subCategory == nil && category == nil
		puts "ALERT =================================="
	end
rescue Exception => e
	puts e
end

puts category
puts subCategory
