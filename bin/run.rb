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

puts "\n\n" 

def get_ingredient_id(name)
    Ingredient.all.find { |ingredient| 
        ingredient.name.downcase == name.downcase ||
        ingredient.name.downcase + "s" == name.downcase ||
        ingredient.name.downcase + " " == name.downcase  
    }.id
end 

def get_recipe_id(name)
    recipe_id = Recipe.all.find {|recipe| recipe.name == name}.id
end 


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
    puts "\n\n"
    puts "------------------------------------------------------------"
    puts "\n"
    selection = @prompt.select("What did you have in mind?\n", [
        "Search for a specific recipe", 
        "View all my recipes" 
    ])

    if selection == "Search for a specific recipe"
        puts "\n"
        recipe_name = @prompt.ask("Which recipe would you like to view?")
        puts "\n"
        Recipe.print_recipe(recipe_name)
    end

    if selection == "View all my recipes"
        puts "\n"
        recipe_name = @prompt.select("Select a recipe", Recipe.populate_recipe_list)
        puts "\n"
        Recipe.print_recipe(recipe_name)
    end 
end

if selection == "Update a recipe"
    puts "\n\n"
    puts "------------------------------------------------------------"
    puts "\n"
    recipe_name = @prompt.select("Select a recipe to update", Recipe.populate_recipe_list)
    puts "\n"
    Recipe.print_recipe(recipe_name)

    selection = @prompt.select("What would you like to do?", [
        "Add an ingredient",
        "Delete an ingredient", 
        "Update a quantity"
    ])

    puts "\n"

    if selection == "Add an ingredient"
        recipe_id = get_recipe_id(recipe_name)
        ingredient = @prompt.ask('Please add an ingredient, e.g. "carrots" --> ')
        Ingredient.create_ingredient(ingredient)
        quantity = @prompt.ask("What quantity of #{ingredient} will you use? --> ")
        "\n"
        ingredient_id = get_ingredient_id(ingredient)
        RecipeIngredient.create_recipe_ingredient(recipe_id, ingredient_id, ingredient, quantity)
        puts "\n"
        puts "----- Recipe updated -----"
    end

    if selection == "Delete an ingredient"
        ingredient = @prompt.ask('Please select an ingredient to remove --> ')
        puts "\n"
        puts "Removing #{ingredient} from #{recipe_name}"
        binding.pry
    end 

end 







