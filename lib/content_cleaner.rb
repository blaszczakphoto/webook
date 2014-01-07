require "sanitize"
require "debugger"
require "iconv"

class ContentCleaner

	def self.clean(content)
		content = force_utf(content)
		Sanitize.clean(content).gsub("\n","").strip		
	end

	def self.force_utf(content)

		ic = Iconv.new('UTF-8', 'UTF-8//IGNORE')
		content = ic.iconv(content + ' ')[0..-2]
		
		return content
	end

end