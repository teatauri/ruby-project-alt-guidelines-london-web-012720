class Ingredient < ActiveRecord::Base
    has_many :recipe_ingredients
    has_many :recipes, through: :recipe_ingredients  

    def self.create_ingredient(name)
        if !self.all.find {|ingredient| ingredient.name.downcase == name.downcase || ingredient.name + "s" == name } 
            self.create(name: name)
        end
    end  
end
