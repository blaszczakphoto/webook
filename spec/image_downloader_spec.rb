# coding: utf-8
require "spec_helper_light"
require "image_downloader"

describe ImageDownloader do
  include HelpersLight

  it "should download all pics from img tags" do
    html = File.open("spec/files/zjp_images/0", "r").read
    book_dir = "spec/files/zjp_images"
    image_downloader = ImageDownloader.new(html, book_dir)
    changed_html = image_downloader.download

    changed_html.should_not include("http://www.teachingtraveling.com")
    changed_html.should include("zjp_images/images")
  end

end