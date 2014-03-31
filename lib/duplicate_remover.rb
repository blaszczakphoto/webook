# coding: utf-8
require "parser_helper"
require "debugger"
require "nokogiri"
require "content_cleaner"
require "duplicate_optimizer"

class DuplicateRemover

	attr_reader :duplicate_optimizer

	def initialize(website)
		@website = website
		@duplicate_optimizer = DuplicateOptimizer.new(@website)
		@subpages = @website.subpages
	end

	def remove
		counter_current = 0
		duplicates_count = 0

		@subpages.each do |subpage|
			@duplicate_optimizer.add(subpage)

			counter_current += 1
			counter_total = @subpages.count
			
			if duplicates_count > 5
				p "optymalizacja w trakcie usuwnia duplikatów.."
				@duplicate_optimizer.optimize!
				duplicates_count = 0
			end
			next unless subpage.valid_page

			if !on_duplicate_list?(subpage.url) || @duplicate_optimizer.pattern?(subpage.url)
				set_duplicate(subpage)
				p subpage.valid_page.to_s + " has pattern" + subpage.url
				next
			end

			p counter_current.to_s + "/" + counter_total.to_s
			p subpage.url + " is examined now..."
			
			@subpages.each do |iterated_subpage|
				next if subpage.url == iterated_subpage.url
				next unless iterated_subpage.valid_page

				if !on_duplicate_list?(iterated_subpage.url) || @duplicate_optimizer.pattern?(iterated_subpage.url)
					set_duplicate(iterated_subpage)
					p " iterated has pattern" + iterated_subpage.url
				elsif DuplicateRemover.is_duplicate?(subpage.content, iterated_subpage.content)
					@duplicate_optimizer.add(iterated_subpage)
					

					duplicate = most_links(subpage, iterated_subpage) || most_headers(subpage, iterated_subpage) || longer_url(subpage, iterated_subpage)
					set_duplicate(duplicate)
					duplicates_count += 1

					p duplicate.url + " is duplicate of " + original(duplicate,subpage, iterated_subpage).url
					break if duplicate == subpage
				end
			end
			p " "
		end

		
		p "valid: "
		@subpages.each{|s| p s.url + " " + s.links_num.to_s if s.valid_page}
		p "invalid: "
		@subpages.each{|s| p s.url + " " + s.links_num.to_s if !s.valid_page}

		p "valid: "
		@subpages.each{|s| p s.url if s.valid_page}
		p "invalid: "
		@subpages.each{|s| p s.url if !s.valid_page}

		return only_valid
	end

	def only_valid
		return @subpages.select {|s| s.valid_page}
	end

	def on_duplicate_list?(url)
		list = ["/category/", "/tag/", "/kategoria/", "/page/"]
		list.each {|item| return false if url.include? item}
		return true
	end

	def original(duplicate, subpage, iterated_subpage)
		return iterated_subpage if subpage == duplicate
		return subpage if iterated_subpage == duplicate
	end

	def set_duplicate(subpage)
		subpage.update_attributes(valid_page: false) if subpage.valid_page
	end

	def sorted_by_similarities(subpages)
		subpages.sort{|a,b| a.similar_subpages.count > b.similar_subpages.count}
	end

	def most_headers(subpage1, subpage2)
		headers1, headers2 = count_headers(subpage1.html), count_headers(subpage2.html)
		return false if headers1 == headers2
		if headers1 > headers2
			return subpage1
		else
			return subpage2
		end
	end

	def most_links(subpage1, subpage2)

		links1, links2 = count_links(subpage1.html), count_links(subpage2.html)
		return false if links1 == links2
		if links1 > links2
			return subpage1
		else # links2 bigger or equal
			return subpage2
		end
	end

	# Return subpage with longer url
	def longer_url(subpage1, subpage2)
		if subpage1.url.length > subpage2.url.length
			return subpage1
		else 
			return subpage2
		end
	end

	def self.is_duplicate?(subpage, iterated_subpage)
		subpage, iterated_subpage = ContentCleaner.clean(subpage), ContentCleaner.clean(iterated_subpage)
		
		if subpage.length > iterated_subpage.length
			longer_text, shorter_text = subpage, iterated_subpage
		else
			longer_text, shorter_text = iterated_subpage, subpage
		end
		(0..shorter_text.length).step(50) do |n|
			text_segment = shorter_text[n, 150]
			return true if text_segment.length == 150 && longer_text.include?(text_segment)
		end
		false
	end

	# Count links within html which are local
	# 
	def count_links(html)
		a_counter = 0
		Nokogiri::HTML(html).search("a").each do |e|
			next unless e.attribute("href")
			if e.attribute("href").content.include?(@website.base_url) || e.attribute("href").content.start_with?("/")
				a_counter+=1 
			end
		end
		a_counter
	end

	def count_headers(html)
		# Count a element within div's which have no siblings
		a_elements = 0
		Nokogiri::HTML(html).search("div > a").each do |e| 
			next if !e.parent || !e.content
			if e.parent.children.count==1 && e.content.length > 3
				a_elements+=1 
			end
		end

		headers = Nokogiri::HTML(html).search("h1, h2, h3, h4, .title").size
		return a_elements + headers
	end

end