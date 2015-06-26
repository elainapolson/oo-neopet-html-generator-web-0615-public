require 'pry'
class User
  
  attr_reader :name
  attr_accessor :neopoints, :items, :neopets

  PET_NAMES = ["Angel", "Baby", "Bailey", "Bandit", "Bella", "Buddy", "Charlie", "Chloe", "Coco", "Daisy", "Lily", "Lucy", "Maggie", "Max", "Molly", "Oliver", "Rocky", "Shadow", "Sophie", "Sunny", "Tiger"]

  def initialize(name)
    @name = name
    @neopoints = 2500
    @items = []
    @neopets = []
  end

  def name_to_slug
    self.name.downcase.gsub(" ", "-")
  end

  def select_pet_name
    pets = self.neopets.collect do |pet|
      pet.name 
    end
    potential_pets = PET_NAMES.select do |name|
      !(pets.include? name)
    end

    potential_pets.sample
  end

  def make_file_name_for_index_page
    self.name.gsub(" ", "-").downcase
  end

  def buy_item
    if self.neopoints.to_i >= 150
      self.neopoints = self.neopoints.to_i - 150
      new_item = Item.new
      self.items << new_item
      "You have purchased a #{new_item.type}."
    else 
      "Sorry, you do not have enough Neopoints."
    end
  end

  def find_item_by_type(type)
    self.items.select{|item| item.type == type}.first
  end

  def buy_neopet
    if self.neopoints.to_i >= 250
      self.neopoints = self.neopoints.to_i - 250
      new_pet = Neopet.new(select_pet_name)
      self.neopets << new_pet
      "You have purchased a #{new_pet.species} named #{new_pet.name}."
    end
  end

  def find_neopet_by_name(name)
    self.neopets.select{|neopet| neopet.name == name}.first
  end

  def sell_neopet_by_name(name)
    self.neopets.collect do |pet| 
      if pet.name == name
        self.neopoints += 200
        self.neopets.delete(self.find_neopet_by_name(name))
        return "You have sold #{name}. You now have #{self.neopoints} neopoints."
      else
        return "Sorry, there are no pets named #{name}."
      end
    end
  end

  def feed_neopet_by_name(name)
    neopet = self.find_neopet_by_name(name)
    if (neopet.happiness == 10)
      "Sorry, feeding was unsuccessful as #{neopet.name} is already ecstatic."
    else
      if neopet.happiness < 9
        neopet.happiness += 2
      elsif neopet.happiness == 9
        neopet.happiness += 1
      end
      "After feeding, #{neopet.name} is #{neopet.mood}."
    end
  end

  def give_present(present, name)
    if self.find_item_by_type(present) == nil || self.find_neopet_by_name(name) == nil
      "Sorry, an error occurred. Please double check the item type and neopet name."
    else
      item = self.find_item_by_type(present)
      neopet = self.find_neopet_by_name(name)
      self.items.delete(item)
      neopet.items << item
      if neopet.happiness <= 5
        neopet.happiness += 5
      else
        neopet.happiness = 10
      end
      "You have given a #{present} to #{name}, who is now #{neopet.mood}."
    end
  end

  def make_index_page
    html = File.read("views/user_page.html.erb")
    template = ERB.new(html)
    result = template.result(binding)
    file = File.write("views/users/#{self.name_to_slug}.html", result)
  end

end







