class Recipe < ActiveRecord::Base
    has_many :recipe_ingredients 
    has_many :ingredients, through: :recipe_ingredients

    def self.create_recipe(name)
        self.create(name: name)
       # id = self.all.find {|recipe| if recipe.name == name ; return recipe.id} 
    end 

    def self.list_recipes
        self.all.each {|recipe| puts recipe.name}
    end 

    def self.find_recipe(name)
        self.all.find do |recipe| 
            if recipe.name.downcase == name.downcase  
                recipe_id = recipe.id
                binding.pry
                arr = RecipeIngredient.all.select {|ele| ele.recipe_id == recipe_id}.flat_map {|ele| [ele.ingredient_id, ele.quantity]}
            end 
        end
    end 

    def list_ingredients
        # id = Recipe.all.find {|recipe| recipe.name == name}.id
        # Recipe.find(id).ingredients # find_by
        # Recipe.all.find_by name: self 
    end
end


