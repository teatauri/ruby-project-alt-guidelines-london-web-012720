class RecipeIngredient < ActiveRecord::Base
    belongs_to :recipe 
    belongs_to :ingredient 

    def self.create_recipe_ingredient(recipe_id, ingredient_id, ingredient_name, quantity)
        self.create(recipe_id: recipe_id, ingredient_id: ingredient_id, ingredient_name: ingredient_name, quantity: quantity)
    end 

    def self.find_recipe_ingredient(recipe_id, ingredient_id)
        self.all.select {|re| re.recipe_id == recipe_id}.find {|ele| ele.ingredient_id == ingredient_id}
    end 

    def self.populate_ingredient_list(recipe_id)
        self.all.select {|ele| ele.recipe_id == recipe_id}.map {|e| e.ingredient_name}
    end 
end
