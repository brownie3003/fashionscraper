def categorize title, cat
	item_title = title.downcase

	# puts title

	puts cat.to_s

	# The magical library catorgrising
	if cat == "Dresses" or cat == "Jumpsuits"
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
		else
			category = "dresses"
			subCategory = nil
		end
	elsif cat == "Coats & Jackets" or cat == "Coats" or cat == "Jackets & Coats" or cat == "Blazers & Waistcoats" or cat == "Blazers" or cat == "Jackets" or cat == "Coats"
		case
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
		when (item_title.to_s.include? "coat" or item_title.to_s.include? "puffer")
			category = "coats"
		else
			category = "coats"
			subCategory = nil
		end
	elsif cat == "Shoes"
		case
		# ============= SHOES =====================
		when (item_title.to_s.include? "heels" or item_title.to_s.include? "heel")
			category = "shoes"
			subCategory = "heels"
		when (item_title.to_s.include? "courts" or item_title.to_s.include? "court")
			category = "shoes"
			subCategory = "court Shoes"
		when (item_title.to_s.include? "boots")
			category = "shoes"
			subCategory = "boots"
		when (item_title.to_s.include? "sandals")
			category = "shoes"
			subCategory = "sandals"
		when (item_title.to_s.include? "slippers")
			category = "shoes"
			subCategory = "slippers"
		when (item_title.to_s.include? "loafers")
			category = "shoes"
			subCategory = "loafers"
		else
			category = "shoes"
			subCategory = nil
		end
	elsif cat == "Skirts"
		case 
		# ============= SKIRTS =====================
		when (item_title.to_s.include? "skirt" or item_title.to_s.include? "kilt")
			category = "skirts"
		else
			category = "skirts"
			subCategory = nil
		end
	elsif cat == "Shirts & Blouses" or cat == "Tops"
		case
		# ============= TOPS =====================
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
		else
			category = "tops"
			subCategory = nil
		end
	elsif cat == "Trousers" or cat == "Jeans" or cat == "Shorts" or cat == "Trousers & Leggings" or cat == "Jeans & Trousers"
		case
		# ============= TROUSERS =====================
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
		when (item_title.to_s.include? "corduroy")
			category = "trousers"
			subCategory = "cordouroy Trousers"
		when (item_title.to_s.include? "shorts" or item_title.to_s.include? "short")
			category = "trousers"
			subCategory = "shorts"
		when (item_title.to_s.include? "leggings" or item_title.to_s.include? "legging")
			category = "trousers"
			subCategory = "leggings"
		when (item_title.to_s.include? "jeggings" or item_title.to_s.include? "jegging")
			category = "trousers"
			subCategory = "jeggings"
		when (item_title.to_s.include? "treggings" or item_title.to_s.include? "tregging")
			category = "trousers"
			subCategory = "treggings"
		else
			category = "trousers"
			subCategory = nil
		end
	elsif cat == "Jumpers" or cat == "Cardigans & Jumpers" or cat == "Hoodies & Sweatshirts" or cat == "Knitwear"
		case
		# ============= JUMPERS =====================
		when (item_title.to_s.include? "sweatshirt" or item_title.to_s.include? "sweater")
			category = "jumpers"
			subCategory = "sweaters"
		when (item_title.to_s.include? "cardigan")
			category = "jumpers"
			subCategory = "cardigans"
		when (item_title.to_s.include? "hoody" or item_title.to_s.include? "hoodie")
			category = "jumpers"
			subCategory = "hoodie"
		when (item_title.to_s.include? "jumper")
			category = "jumpers"
		else
			category = "jumpers"
			subCategory = nil
		end
	elsif cat == "Nightwear" or cat == "Lingerie & Nightwear" or cat == "Sleep & Lounge"
		case 
		# ============= LINGERIE =====================
		when (item_title.to_s.include? "pyjama")
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
		when (item_title.to_s.include? "slippers")
			category = "nightwear"
			subCategory = "slippers"
		else
			category = "Nightwear"
			subcategory = nil
		end
	elsif cat == "Swimwear & Beachwear" or cat == "Swimwear"
		case 
		# ============= SWIMWEAR =====================
		when (item_title.to_s.include? "bikini")
			category = "swimwear"
			subCategory = "bikinis"
		else
			category = "Swimwear"
			subCategory = nil
		end
	elsif cat == "Accessories" or cat == "Bags"
		case 
		# ============= ACCESSORIES =====================
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
		when (item_title.to_s.include? "gloves" or item_title.to_s.include? "mittens")
			category = "accessories"
			subCategory = "gloves"
		when (item_title.to_s.include? "belt")
			category = "accessories"
			subCategory = "belts"
		else
			category = "Accessories"
			subCategory = nil
		end
	elsif cat == "Jersey Tops" or cat == "Tops"
		case 
		# ============= TOPS =====================
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
		else
			category = "Tops"
			subCategory = nil
		end
	else
		# This is the catchall for something that doesn't have a category
		# Can lead to massive fuck ups e.g. pyjama trousers are tagged as trousers
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
		
		# ============= JUMPERS =====================
		when (item_title.to_s.include? "sweatshirt" or item_title.to_s.include? "sweater")
			category = "jumpers"
			subCategory = "sweaters"
		when (item_title.to_s.include? "cardigan")
			category = "jumpers"
			subCategory = "cardigans"
		when (item_title.to_s.include? "jumper")
			category = "jumpers"
		
		# ============= TOPS =====================
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

		# ============= TROUSERS =====================
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
		when (item_title.to_s.include? "jeggings" or item_title.to_s.include? "jegging")
			category = "trousers"
			subCategory = "jeggings"
		when (item_title.to_s.include? "treggings" or item_title.to_s.include? "tregging")
			category = "trousers"
			subCategory = "treggings"
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
		when (item_title.to_s.include? "pyjama")
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
	end

	# puts category.to_s + " inside"
	# puts subCategory.to_s + " inside"


	if category != nil
		category.capitalize!
	end
	if subCategory != nil
		subCategory.capitalize!
	end

	return category, subCategory
end

# example of categorize usage
# title = "Stretch trousers"
# cat = "Trousers"

# begin
# 	category, subCategory = categorize title, cat
# 	if subCategory == nil && category == nil
# 		puts "ALERT =================================="
# 	end
# rescue Exception => e
# 	puts e
# end

# puts category
# puts subCategory
