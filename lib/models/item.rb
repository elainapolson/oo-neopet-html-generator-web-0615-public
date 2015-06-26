class Item
  
  attr_reader :type

  def initialize
    @type = get_type
  end

  def get_type
    Dir["public/img/items/*.jpg"].collect do |file|
      file.gsub("public/img/items/", "")
    end.sample.gsub(".jpg", "")
  end

  def format_type
    @type = self.type.gsub("_", " ").capitalize
  end

end