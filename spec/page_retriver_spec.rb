# coding: utf-8
require "page_retriver"


describe PageRetriver do

  example "should open valid websites" do
    html = PageRetriver.retrive("http://www.zyciejestpiekne.eu/gdzie-ruszam-w-2014-roku/")
    expect(html).to include("ezent zafundować blogowi? Oczywiście, że podróżniczy!")

    html = PageRetriver.retrive("http://i1.wp.com/www.zyciejestpiekne.eu/wp-content/uploads/ikonka-wpisu.jpg?resize=230%2C163")
    expect(html).to eq(false)
  end

end