class Recipe < ActiveRecord::Base
    has_many :recipe_ingredients 
    has_many :ingredients, through: :recipe_ingredients

    def self.create_recipe(name)
        self.create(name: name)
        # @prompt = TTY::Prompt.new
        # if self.list_recipes.include?(name)
        #     puts "Opps! That name is already taken."
        #     new_name = @prompt.ask('Choose another name --> ')
        #     self.create(name: new_name)
        # else 
        #     self.create(name: name)
        # end 
    end 

    def self.list_recipes
        self.all.map {|recipe| recipe.name}
    end 

    def self.print_recipe(name)
        ingredients = []
        self.all.find do |recipe| 
            if recipe.name.downcase == name.downcase  
                recipe_id = recipe.id
                list = RecipeIngredient.all.select {|e| e.recipe_id == recipe_id}.map {|e| ["#{e.ingredient_name} ---> ", "#{e.quantity}\n"]}
                puts "Your recipe for #{name.upcase} is as follows -->\n\n"
                ingredients << list
                puts ingredients.join
                puts "\n------------------------------------------------------------"
            end 
        end  
        #Api.call_api(name, ingredients)  
    end 

    def self.populate_recipe_list 
        self.list_recipes.sort.split
    end 

    def self.get_recipe_id(name)
        recipe_id = self.all.find {|recipe| recipe.name == name}.id
    end 

end


