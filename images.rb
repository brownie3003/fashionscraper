require 'rubygems'
require 'mechanize'
require 'open-uri'

agent = Mechanize.new

agent.get("http://www.zara.com/uk/en/new-this-week/woman/combined-faux-leather-coat-c287002p1576510.html");

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
	imageLinks.each do |link|
		imageUrls["image#{i}"] = "http:" + link
		i +=1
	end
end

materials = agent.page.search(".composition ul div p").text.strip.delete("\r").delete("\t")

puts materials



item = {
	"name" => "Topshop",
	"images" => imageUrls
}

# How to get a certain image.
#puts item["images"]["image1"]