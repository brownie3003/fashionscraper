require 'mechanize'
require 'nokogiri'
require 'open-uri'
require "mongo"
require "json"

agent = Mechanize.new

agent.get("http://www.topshop.com/");

agent.page.link_with(text: "New In This Week").click

page_links = agent.page.search(".cf ul li a")

link_titles = Array.new

page_links.each do |link|
	link_titles << link.text
end

## Create an array of all the categories, look over the array, for each element get the href of the link, create a new agent_#{element} = Mechanize.new which will go and do all the shit required.

dresses_index = link_titles.index{|title| title.include?("Dresses & Playsuits")}

#puts dresses_index

dresses = link_titles[link_titles.index{|title| title.include?("Dresses & Playsuits")}]
# puts dresses


agent.page.link_with(text: dresses).click

products = agent.page.search(".product_description a").map(&:text)

#puts products

productLinks = Array.new

products.each do |name|
	productLinks << agent.page.link_with(text: "#{name}").href
end

# puts productLinks

productLinks.each do |link|
	agent.get("#{link}")

	title = agent.page.search("h1").text.strip

	images = agent.page.search(".product_view")
	imageLinks = Array.new

	images.each do |element|
		link = element.attr('href')
		imageLinks << link

		i = 2
		check_image = true

		until check_image == false do
			baseLink = link.slice(0..-10)
			begin
				page = agent.get(baseLink + "#{i}_large.jpg")
			rescue Exception => e
				check_image = false
			end
			if check_image == true
	 			imageLinks << baseLink + ("#{i}_large.jpg")
	 		end
			i += 1
	 	end
	end

	# puts imageLinks
end



