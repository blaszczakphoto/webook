# coding: utf-8
require "parser_helper"
require "debugger"
require "nokogiri"
require "content_cleaner"
require "duplicate_optimizer"

class DuplicateRemover

	attr_reader :duplicate_optimizer

	def initialize(website)
		@duplicate_optimizer = DuplicateOptimizer.new(website)
	end

	def remove(subpages)
		counter_current = 1
		duplicates_count = 0

		subpages.each do |subpage|
			@duplicate_optimizer.add(subpage)

			counter_current += 1
			counter_total = subpages.count
			p counter_current.to_s + "/" + counter_total.to_s
			p subpage.url + " is examined now..."

			if duplicates_count > 10
				p "optymalizacja w trakcie usuwnia duplikatów.."
				@duplicate_optimizer.optimize!
				duplicates_count = 0
			end
			next unless subpage.valid_page

			if @duplicate_optimizer.pattern?(subpage.url)
				set_duplicate(subpage)
				p subpage.valid_page.to_s + " has pattern" + subpage.url
				next
			end
			
			subpages.each do |iterated_subpage|
				next if subpage.url == iterated_subpage.url
				next unless iterated_subpage.valid_page

				if @duplicate_optimizer.pattern?(iterated_subpage.url)
					set_duplicate(iterated_subpage)
					p " iterated has pattern" + iterated_subpage.url
				elsif DuplicateRemover.is_duplicate?(subpage.content, iterated_subpage.content)
					@duplicate_optimizer.add(iterated_subpage)
					duplicate = most_headers(subpage, iterated_subpage) || most_links(subpage, iterated_subpage) || longer_url(subpage, iterated_subpage)
					set_duplicate(duplicate)
					duplicates_count += 1
					p duplicate.url + " is duplicate"
				end
			end
			p " "
		end

		return only_valid(subpages)
	end

	def only_valid(subpages)
		return subpages.select {|s| s.valid_page}
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

	def count_links(html)
		Nokogiri::HTML(html).search("a").size
	end

	def count_headers(html)
		Nokogiri::HTML(html).search("h1, h2, h3, h4, .title").size
	end

end