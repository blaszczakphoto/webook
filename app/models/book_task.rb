class BookTask < ActiveRecord::Base
  attr_accessible :email, :links, :name, :title, :dir, :file, :downloaded
  validates_presence_of :email
  validates_presence_of :links
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

 	def links_as_array
 		links.gsub("\r", "").split("\n").reject { |c| c.empty? }
 	end

 	def file_url
		file.gsub(/.*(?<el>public)/, '')
 	end

end
