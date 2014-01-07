require 'open-uri'



class PageRetriver

	def self.retrive(url)
		false unless PageValidator.valid?(url)
		begin
			@response = open(url)
		rescue
			false
		else
			if proper_response?
				ContentCleaner.force_utf(@response.read)
			else
				false
			end
		end
	end

	def self.proper_response?
		@response.status[0] == "200" && @response.content_type == "text/html"
	end
end