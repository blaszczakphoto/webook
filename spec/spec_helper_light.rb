require "content_finder"
require "header_finder"

module HelpersLight
	
	def create_website(attrs)
		website = double("website")
    attrs.each {|key, item| website.stub(key) {item}}
    website
	end

	def create_subpage(attrs)
		subpage = double("subpage")
		subpage.stub(:update_attributes).with(valid_page: false) {subpage.stub(valid_page: false)}
		
		attrs.each {|key, item| subpage.stub(key) {item}}
		subpage
	end

	def create_subpages(urls, dir, attrs)
		subpages = []
		urls.each_with_index do |url, index| 
      file = File.open("#{dir}#{index}", "r").read
      data = file.split("PHafrAWuwrUf7S*UkEp&")
      attrs[:html] = data[0]
      attrs[:content] = data[1]
      attrs[:title] = data[2]
      attrs[:url] = url
      subpages.push(create_subpage(attrs))
    end
    subpages
	end

	def find_by_url(subpages, url)
		#TODO: 
	end
 
end
