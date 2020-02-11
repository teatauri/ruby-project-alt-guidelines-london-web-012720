class RecipeIngredient < ActiveRecord::Base
    belongs_to :recipe 
    belongs_to :ingredient 

    def self.create_recipe_ingredient(recipe_id, ingredient_id, ingredient_name, quantity)
        self.create(recipe_id: recipe_id, ingredient_id: ingredient_id, ingredient_name: ingredient_name, quantity: quantity)
    end 
end