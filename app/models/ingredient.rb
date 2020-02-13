class Ingredient < ActiveRecord::Base
    has_many :recipe_ingredients
    has_many :recipes, through: :recipe_ingredients  

    def self.find_ingredient(name)
        self.all.find { |ingredient| 
        ingredient.name == name || 
        ingredient.name + "s" == name ||
        ingredient.name + " " == name
        }
    end 
    
    def self.create_ingredient(name)
        if !self.find_ingredient(name)
            self.create(name: name)
        end
    end  

    def self.get_ingredient_id(name)
        self.find_ingredient(name).id
    end 
    
end
