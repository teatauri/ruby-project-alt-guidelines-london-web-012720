require_relative '../config/environment.rb'

require 'tty-prompt'

puts " 
                                                                            
         _____ _____    _____ _____ __    _____ _____ _____ _____ _____ _____         
 ___ ___|     | __  |  |     |  _  |  |  |     | __  |     |__   |   __| __  |___ ___ 
|___|___| | | |    -|  |   --|     |  |__|  |  |    -|-   -|   __|   __|    -|___|___|
        |_|_|_|__|__|  |_____|__|__|_____|_____|__|__|_____|_____|_____|__|__|        
                                                                                                           
=============================== The Calorie-Counter ==================================                                                                      
                                                                                                 
"
@prompt = TTY::Prompt.new

selection = @prompt.select("What would you like to do?", [
    "Create a new recipe", 
    "View an existing recipe", 
    "Update a recipe", 
    "Delete a recipe"
])

    puts "\n"
    puts "----------------------------------------------------------------"
    puts "\n"

if selection == "Create a new recipe"
    ingredient_array = []
    recipe_name = @prompt.ask('What would you like to call this recipe? -->')
    Recipe.create_recipe(recipe_name)
    recipe_id = Recipe.all.find {|recipe| recipe.name == recipe_name}.id

    puts "\n"
    puts "----------------------------------------------------------------"
    puts "\n"

    ingredient = @prompt.ask('Please add an ingredient, e.g. "carrots" --> ')
    ingredient_array << ingredient
    Ingredient.create_ingredient(ingredient)

    more = @prompt.yes?('Would you like to add another ingredient?')
    while more do
        ingredient = @prompt.ask('Add another ingredient -->') 
        Ingredient.create_ingredient(ingredient)
        ingredient_array << ingredient 
        more = @prompt.yes?('Would you like to add another ingredient?')
    end

    puts "\n"
    puts "------------------------------------------------------------"
    puts "\n"

    def get_ingredient_id(name)
        Ingredient.all.find {|ingredient| ingredient.name == name}.id
    end 

    recipe_array = []
    ingredient_array.each do |ingredient|
        quantity = @prompt.ask("What quantity of #{ingredient} will you use? --> ")
        "\n"
        recipe_array << "#{quantity} #{ingredient}"
        ingredient_id = get_ingredient_id(ingredient)
        RecipeIngredient.create_recipe_ingredient(recipe_id, ingredient_id, ingredient, quantity)
    end 

    puts "\n\n"
    puts "------------------------------------------------------------"
    puts "\n"
    puts "Your recipe for #{recipe_name.upcase} is as follows: \n\n"
    puts recipe_array
    puts "\n"
end 


if selection == "View an existing recipe"
    @prompt = TTY::Prompt.new
    recipe_name = @prompt.ask("Which recipe would you like to view?")
    puts "\n"
    Recipe.find_recipe(recipe_name)
    # recipe = Recipe.list_recipes
    # recipe_name = @prompt.ask('Which recipe would you like to adjust?', recipes)
end







