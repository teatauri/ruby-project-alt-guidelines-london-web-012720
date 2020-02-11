class Recipe < ActiveRecord::Base
    has_many :recipe_ingredients 
    has_many :ingredients, through: :recipe_ingredients

    def self.create_recipe(name)
        self.create(name: name)
    end 

    def self.list_recipes
        self.all.map {|recipe| recipe.name}
    end 

    def self.print_recipe(name)
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

    def self.populate_recipe_list 
        self.list_recipes.sort.split
    end 

    def self.list_ingredients(name)
        id = Recipe.all.find {|recipe| recipe.name == name}.id
        Recipe.find(id).ingredients.map {|ingredient| ingredient.name}# find_by
        # Recipe.all.find_by name: self 
    end
end


