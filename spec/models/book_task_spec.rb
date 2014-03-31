require 'spec_helper'
require 'spec_helper_light'

describe BookTask do
	include HelpersLight

	before(:all) do
		file_content = open_file("#{Rails.root}/spec/files/book_task_model/links")
		@book_task = BookTask.create(title: "Nowa Kniga", email: "mariusz.blaszczak@gmail.com", links: file_content, file: "/home/mariusz/Projects/webook/public/books/dir/kindle.mobi")
	end

	it "should return array from links" do
		expect(@book_task.links_as_array.count).to eq(3)
	end

	it "should contain all links" do
		expect(@book_task.links_as_array).to include("www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/")
		expect(@book_task.links_as_array).to include("http://www.peron4.pl/serbia-bierzcie-i-jedzcie/")
		expect(@book_task.links_as_array).to include("http://jamesgolick.com/2010/3/14/crazy-heretical-and-awesome-the-way-i-write-rails-apps.html")
	end

	it "should return proper url of kindle file" do
		expect(@book_task.file_url).to eq("/public/books/dir/kindle.mobi")
	end

	it "should deliver email" do
		NotificationsMailer.new_message(@book_task).deliver
	end

end
