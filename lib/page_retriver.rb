require 'open-uri'
require "page_validator"
require "content_cleaner"

class ResponseCanNotBeBlank < StandardError; end

class PageRetriver

	def self.retrive(url)
		
		false unless PageValidator.valid?(url)
		begin
			@response = open(url)
		rescue
			false
		else
			if proper_response?
				@content = ContentCleaner.force_utf(@response.read)
				return @content if proper_content?
			else
				false
			end
		end
	end

	def self.proper_response?
		@response.status[0] == "200" && @response.content_type == "text/html"
	end

	def self.proper_content?
		@content.length > 100
	end


end