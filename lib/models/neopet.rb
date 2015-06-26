class Neopet

  attr_reader :name, :species, :strength, :defence, :movement
  attr_accessor :happiness, :items, :mood
  
  def initialize(name)
    @name = name
    @strength = get_points
    @defence = get_points
    @movement = get_points
    @happiness = get_points
    @species = get_species
    @items = []
  end

  def get_points
    rand(1..10)
  end

  def get_species
    Dir["public/img/neopets/*.jpg"].collect do |file|
      file.gsub("public/img/neopets/", "")
    end.sample.gsub(".jpg", "")
  end

  def mood
    case happiness
    when 1..2
      @mood = "depressed"
    when 3..4
      @mood = "sad"
    when 5..6
      @mood = "meh"
    when 7..8
      @mood = "happy"
    when 9..10
      @mood = "ecstatic"
    end
  end

end