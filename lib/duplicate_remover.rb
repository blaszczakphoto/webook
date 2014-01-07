require "parser_helper"
require "debugger"
require "nokogiri"


class DuplicateRemover

	def self.remove(subpages)
		@subpages = subpages
		subpages.each do |subpage|
			subpages_without_current(subpages, subpage).each do |iterated_subpage|
				if !iterated_subpage.valid_page
					@subpages.delete(iterated_subpage)
				elsif !subpage.valid_page
					@subpages.delete(subpage)
				elsif is_duplicate?(subpage, iterated_subpage)
					duplicate = most_headers(subpage, iterated_subpage) || most_links(subpage, iterated_subpage)
					set_duplicate(duplicate)
				end
			end
		end
	end

	def self.set_duplicate(subpage)
		subpage.update_attributes(valid_page: false)
		@subpages.delete(subpage)
	end

	def self.sorted_by_similarities(subpages)
		subpages.sort{|a,b| a.similar_subpages.count > b.similar_subpages.count}
	end

	def self.most_headers(subpage1, subpage2)
		headers1, headers2 = count_headers(subpage1.html), count_headers(subpage2.html)
		false if headers1 == headers2
		if headers1 > headers2
			return subpage1
		else
			return subpage2
		end
	end

	def self.most_links(subpage1, subpage2)
		links1, links2 = count_links(subpage1.html), count_links(subpage2.html)
		false if links1 == links2
		if links1 > links2
			return subpage1
		else
			return subpage2
		end
	end

	def self.subpages_without_current(subpages, subpage)
		subpages_without_current = subpages.clone
		subpages_without_current.delete(subpage)
		subpages_without_current
	end

	def self.is_duplicate?(subpage, iterated_subpage)
		subpage, iterated_subpage = subpage.clean_content, iterated_subpage.clean_content
		maxlen = subpage.length
		maxlen.downto(0) do |len|
			next unless len % 30 == 0
			0.upto(maxlen - len) do |start|
				next unless start % 30 == 0
        break if (len - start) < 100 # Common part must be longer than 100 chars
        return true if iterated_subpage.include?(subpage[start,len])
      end
    end
    return false
  end

  def self.count_links(html)
  	Nokogiri::HTML(html).search("a").size
  end

  def self.count_headers(html)
  	Nokogiri::HTML(html).search("h1, h2, h3, h4, .title").size
  end

end