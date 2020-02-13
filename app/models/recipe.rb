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
        self.call_api(name, ingredients)  
    end 

    def self.call_api(name, ingredients)
        ingredientArray = ingredients.join.delete('--->').split(/\n/)
        # binding.pry
        body = { "title": name, "ingr": ingredientArray }.to_json
        response = RestClient.post(
            "https://api.edamam.com/api/nutrition-details?app_id=2f6b3adf&app_key=01bac796edcb5cb7823a8de1c2830769",
            body,
            { content_type: :json },
        )
        info = JSON.parse(response)
        puts "Your recipe contains #{info['calories']} calories"
        puts "\n\n"
        puts "------------------------------------------------------------"
    end 

    def self.populate_recipe_list 
        self.list_recipes.sort.split
    end 

    def self.get_recipe_id(name)
        recipe_id = self.all.find {|recipe| recipe.name == name}.id
    end 

end


