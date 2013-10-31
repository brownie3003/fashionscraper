require 'mechanize'
require 'nokogiri'
require 'open-uri'
require 'mongo'
require 'json'
require './categorize'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'


categories_hash = Hash.new

categories_hash = {
	"Dresses" => "http://www.newlook.com/shop/new-in/view-all/clothing/dresses/_/N-bi6Zepo?No=0&Nrpp=200",
	"Jackets & Coats" => "http://www.newlook.com/shop/new-in/view-all/clothing/jackets-coats/_/N-bi6Zeps?No=0&Nrpp=200",
	"Jeans" => "http://www.newlook.com/shop/new-in/view-all/clothing/jeans/_/N-bi6Zepv?No=0&Nrpp=200",
	"Knitwear" => "http://www.newlook.com/shop/new-in/view-all/clothing/knitwear/_/N-bi6Zepy?No=0&Nrpp=200",
	"Leggings" => "http://www.newlook.com/shop/new-in/view-all/clothing/leggings/_/N-bi6Zeq1?No=0&Nrpp=200",
	"Skirts" => "http://www.newlook.com/shop/new-in/view-all/clothing/skirts/_/N-bi6Zeq9?No=0&Nrpp=200",
	"Tops" => "http://www.newlook.com/shop/new-in/view-all/clothing/tops/_/N-bi6Zeqe?No=0&Nrpp=200",
	"Trousers & Shorts" => "http://www.newlook.com/shop/new-in/view-all/clothing/trousers-shorts/_/N-bi6Zeqj?No=0&Nrpp=200"
}

categories_hash.each do |cat, link|
	puts cat
	
	agent.get(link)

	products = agent.page.search(".desc a").map(&:text)
	puts cat + " " + products.to_s

	product_links = Array.new

	products.each do |name|
		product_links << "http://www.newlook.com" + agent.page.link_with(text: name).href
	end

	shop = "New Look"

	product_links.each do |link|
	 	agent.get(link)

	# 	title = agent.page.search("h1").text.strip
	# 	puts title

	# 	image = agent.page.search()
	end
end