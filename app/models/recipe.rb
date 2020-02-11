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
                arr = RecipeIngredient.all.select {|ele| ele.recipe_id == recipe_id}.map {|ele| ["#{ele.ingredient_name} ---> ", "#{ele.quantity}\n"]}
                puts "Your recipe for #{name.upcase} is as follows -->\n\n"
                puts arr.join
                puts "\n"
                puts "------------------------------------------------------------"
                puts "\n"
            end 
        end
    end 

    def list_ingredients
        # id = Recipe.all.find {|recipe| recipe.name == name}.id
        # Recipe.find(id).ingredients # find_by
        # Recipe.all.find_by name: self 
    end
end


