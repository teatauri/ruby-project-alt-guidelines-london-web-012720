class RecipeIngredient < ActiveRecord::Base
    belongs_to :recipe 
    belongs_to :ingredient 

    def self.create_recipe_ingredient(recipe_id, ingredient_id, ingredient_name, quantity)
        self.create(recipe_id: recipe_id, ingredient_id: ingredient_id, ingredient_name: ingredient_name, quantity: quantity)
    end 

    # def self.populate_ingredient_list
    #     binding.pry
    # end 
    # def self.create_recipe_ingredient(recipe_id, ingredient_id, ingredient_name, quantity)
    #     if !self.all.find { |rec_ingredient| 
    #         rec_ingredient.name.downcase == ingredient_name.downcase || 
    #         rec_ingredient.name.downcase + "s" == ingredient_name.downcase ||
    #         rec_ingredient.name.downcase + " " == ingredient_name.downcase
    #     } 
    #     self.create(recipe_id: recipe_id, ingredient_id: ingredient_id, ingredient_name: ingredient_name, quantity: quantity) 
    #     end
    # end  
end
