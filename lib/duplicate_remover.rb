require "parser_helper"
require "debugger"
require "nokogiri"
require "content_cleaner"

class DuplicateRemover

	def self.remove(subpages)
		@subpages = subpages
		counter_total = @subpages.count
		counter_current = 0
		subpages.each do |subpage|
			puts "*"*5 + "usuwanie...  " + counter_total.to_s + " / " + counter_current.to_s + "*"*5
			counter_current += 1
			subpages_without_current(subpage).each do |iterated_subpage|
				if !iterated_subpage.valid_page
					set_duplicate(iterated_subpage)
					# @subpages.delete(iterated_subpage)
				elsif !subpage.valid_page
					set_duplicate(subpage)
					# @subpages.delete(subpage)
				elsif is_duplicate?(subpage.content, iterated_subpage.content)
					duplicate = most_headers(subpage, iterated_subpage) || most_links(subpage, iterated_subpage)
					set_duplicate(duplicate)
				end
			end
		end
	end


	def self.set_duplicate(subpage)
		if subpage && Subpage.exists?(subpage) 
			subpage.update_attributes(valid_page: false)
			@subpages.delete(subpage)
		end
	end

	def self.sorted_by_similarities(subpages)
		subpages.sort{|a,b| a.similar_subpages.count > b.similar_subpages.count}
	end

	def self.most_headers(subpage1, subpage2)
		headers1, headers2 = count_headers(subpage1.html), count_headers(subpage2.html)
		return false if headers1 == headers2
		if headers1 > headers2
			return subpage1
		else
			return subpage2
		end
	end

	def self.most_links(subpage1, subpage2)
		links1, links2 = count_links(subpage1.html), count_links(subpage2.html)
		return false if links1 == links2
		if links1 > links2
			return subpage1
		else
			return subpage2
		end
	end

	def self.subpages_without_current(subpage)
		subpages_without_current = @subpages.clone
		subpages_without_current.delete(subpage)
		subpages_without_current
	end

	def self.is_duplicate?(subpage, iterated_subpage)

		subpage, iterated_subpage = ContentCleaner.clean(subpage), ContentCleaner.clean(iterated_subpage)

		if subpage.length > iterated_subpage.length
			longer_text, shorter_text = subpage, iterated_subpage
		else
			longer_text, shorter_text = iterated_subpage, subpage
		end

		(0..shorter_text.length).step(25) do |n|
			text_segment = shorter_text[n, n+50]
			return true if text_segment.length == 50 && longer_text.include?(shorter_text[n, n+50])
		end
		false
  end


  def self.count_links(html)
  	Nokogiri::HTML(html).search("a").size
  end

  def self.count_headers(html)
  	Nokogiri::HTML(html).search("h1, h2, h3, h4, .title").size
  end

end