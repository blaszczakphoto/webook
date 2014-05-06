require "nokogiri"
require "debugger"
require 'open-uri'

class ImageDownloader

	def initialize(html, book_dir)
		@book_dir = book_dir
		@html = html
	end

	# Process images of html, store locally and return html with changed paths
	def download
		@images_dir = "#{@book_dir}/images"
		FileUtils.makedirs(@images_dir) unless File.exists?(@images_dir)
		doc = Nokogiri::HTML(@html)

		doc.search("img").each do |img|
			new_path = store_image(img, new_path(img))
			if new_path
				img.attribute("src").value = new_path
			else
				img.remove
			end
		end
		doc.to_html
	end

	# Generate random string
	def new_path(img)
		name = (0...8).map { (65 + rand(26)).chr }.join
		ext = File.extname(img.attribute("src").value)
		file_name = "#{name}#{ext}"
		return "#{@images_dir}/#{file_name}"
	end

	# Open and store image
	def store_image(img, new_path)
		begin
			url = prepare_src(img.attribute("src").value)
			response = open(url)
			if response.content_type.include?("image")
				File.open(new_path, 'wb') {|f| f.write(response.read)}
			else
				new_path = false
			end
		rescue
			new_path = false
		end
		return new_path
	end

	def prepare_src(src)
		src.gsub("..", "")
	end

end