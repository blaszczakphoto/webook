# coding: utf-8
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

	def create_subpages_without_content(urls, attrs)
		subpages = []
		urls.each {|subpage| subpages.push(create_subpage(attrs))}
		subpages
	end

	def create_subpages(urls, dir, attrs)
		subpages = []
		urls.each_with_index do |url, index| 
      file = File.open("#{dir}#{index}", "r").read

      data = file.encode('utf-8', 'binary', :invalid => :replace, :undef => :replace).split("PHafrAWuwrUf7S*UkEp&")
      obj_attrs = attrs.clone
      obj_attrs[:html] = data[0]
      obj_attrs[:content] = data[1]
      obj_attrs[:title] = data[2]
      obj_attrs[:url] = url
      obj_attrs[:valid_page] = false if data[1].length < 3 #if content empty valid page false
      subpages.push(create_subpage(obj_attrs))
    end
    subpages
	end

	def find_by_url(subpages, url)
		#TODO: 
	end

end