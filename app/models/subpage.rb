class Subpage < ActiveRecord::Base
  belongs_to :page
  attr_accessible :title, :url, :datetime, :content

  def self.create_from_url(url, page)
    subpage = Subpage.new
    subpage.title = "Example title"
    subpage.url = url
    subpage.datetime = Time.now
    subpage.content = "content"
    subpage.page = page
    subpage.save!
  end

  def readibility!
    content = "readibility"
    self.save
  end

end