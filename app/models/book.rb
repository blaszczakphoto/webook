class Book
  include ActiveModel::Conversion
  include ActiveModel::Serialization
  extend ActiveModel::Naming

  attr_accessor :content, :website

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end  

  def chapters
    website.subpages
  end

end
