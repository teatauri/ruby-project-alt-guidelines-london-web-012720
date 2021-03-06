# require 'tty-prompt'
# # require 'tty-box'
# require 'catpix'

class CLI

    def initialize
        @prompt = TTY::Prompt.new
    end
  
    def start
        puts "               
        
        
  _______  _______  ___      _______  ______    ___   _______    _______  _______  __   __  __   __  _______  __    _  ______   _______  ______   
 |       ||   _   ||   |    |       ||    _ |  |   | |       |  |       ||       ||  |_|  ||  |_|  ||   _   ||  |  | ||      | |       ||    _ |  
 |       ||  |_|  ||   |    |   _   ||   | ||  |   | |    ___|  |       ||   _   ||       ||       ||  |_|  ||   |_| ||  _    ||    ___||   | ||  
 |       ||       ||   |    |  | |  ||   |_||_ |   | |   |___   |       ||  | |  ||       ||       ||       ||       || | |   ||   |___ |   |_||_ 
 |      _||       ||   |___ |  |_|  ||    __  ||   | |    ___|  |      _||  |_|  ||       ||       ||       ||  _    || |_|   ||    ___||    __  |
 |     |_ |   _   ||       ||       ||   |  | ||   | |   |___   |     |_ |       || ||_|| || ||_|| ||   _   || | |   ||       ||   |___ |   |  | |
 |_______||__| |__||_______||_______||___|  |_||___| |_______|  |_______||_______||_|   |_||_|   |_||__| |__||_|  |__||______| |_______||___|  |_|
 
 ===================================================== The Commandline Calorie-Counter ==========================================================                                                                     
                                                                                                    
        "
        main_menu
    end
    
    def main_menu
        selection = @prompt.select("------------ MAIN MENU -----------\n\n", [
            "Create a New Recipe", 
            "View Recipe & Nutritional Info", 
            "Update a Recipe", 
            "Delete a Recipe \n\n\n\n"
        ])

        if selection == "Create a New Recipe"
            new_recipe 
        elsif selection == "View Recipe & Nutritional Info"
            view_recipes_and_nutrition 
        elsif selection == "Update a Recipe" 
            update_recipe 
        else 
            delete_recipe 
        end 
    end

    def new_recipe 
        recipe_name = @prompt.ask('What would you like to call this recipe? -->').downcase
        Recipe.create_recipe(recipe_name)
        recipe_id = Recipe.get_recipe_id(recipe_name)
        ingredient_array = add_ingredients(recipe_id)
        puts "\n"
        puts "------------------------------------------------------------\n"
        recipe_array = []
        ingredient_array.each do |ingredient|
            quantity = @prompt.ask("What quantity of #{ingredient} will you use? --> ")
            "\n"
            recipe_array << "#{quantity} #{ingredient}"
            ingredient_id = Ingredient.get_ingredient_id(ingredient)
            RecipeIngredient.create_recipe_ingredient(recipe_id, ingredient_id, ingredient, quantity)
        end 
        
        puts "\n\n"
        puts "------------------------------------------------------------\n"
        puts "Your recipe for #{recipe_name.upcase} is as follows: \n\n"
        puts recipe_array
        puts "\n\n"
        menu_or_exit
    end 

    def add_ingredients(recipe_id)
        ingredient_array = []
        ingredient = @prompt.ask('Please add an ingredient WITHOUT quantity, e.g. "carrots" --> ')
        ingredient_array << ingredient
        Ingredient.create_ingredient(ingredient)
        more = @prompt.yes?('Would you like to add another ingredient?')
        while more do
            ingredient = @prompt.ask('Add another ingredient -->') 
            Ingredient.create_ingredient(ingredient)
            ingredient_array << ingredient 
            more = @prompt.yes?('Would you like to add another ingredient?')
        end
        ingredient_array
    end 

    def view_recipes_and_nutrition
        puts "\n\n"
        puts "------------------------------------------------------------"
        puts "\n"
        recipe_name = @prompt.select("Select a recipe ", Recipe.populate_recipe_list)
        puts "\n"
        Recipe.print_recipe(recipe_name)
        menu_or_exit 
    end 

    def update_recipe
        puts "\n\n"
        recipe_name = @prompt.select("Select a recipe to update", Recipe.populate_recipe_list)
        puts "\n"
        Recipe.print_recipe(recipe_name)
        recipe_id = Recipe.get_recipe_id(recipe_name) 
        selection = @prompt.select("What would you like to do?", [
            "Add an ingredient",
            "Delete an ingredient", 
            "Update a quantity"
        ])
        if selection == "Add an ingredient"
            add_ingredient(recipe_id, recipe_name)
        elsif selection == "Delete an ingredient"
            delete_ingredient(recipe_id, recipe_name) 
        else 
            update_quantity(recipe_id, recipe_name) 
        end 
        puts "\n"
        menu_or_exit
    end

    def add_ingredient(recipe_id, recipe_name)
        ingredient = @prompt.ask('Please add an ingredient, e.g. "carrots" --> ')
        Ingredient.create_ingredient(ingredient)
        puts "\n"
        quantity = @prompt.ask("What quantity of #{ingredient} will you use? --> ")
        ingredient_id = Ingredient.get_ingredient_id(ingredient)
        RecipeIngredient.create_recipe_ingredient(recipe_id, ingredient_id, ingredient, quantity)
        puts "\n"
        puts "------------------ RECIPE UPDATED -----------------------\n"
        puts "\n"
        Recipe.print_recipe(recipe_name)
    end

    def delete_ingredient(recipe_id, recipe_name)
        ingredient = @prompt.select('Please select an ingredient to remove --> ', RecipeIngredient.populate_ingredient_list(recipe_id))
        ingredient_id = Ingredient.get_ingredient_id(ingredient)
        RecipeIngredient.find_recipe_ingredient(recipe_id, ingredient_id).delete
        puts "\n\n"
        puts "------------------ RECIPE UPDATED -----------------------"
        puts "\n"
        Recipe.print_recipe(recipe_name)
    end 

    def update_quantity(recipe_id, recipe_name)
        ingredient = @prompt.select('Please select an ingredient to update --> ', RecipeIngredient.populate_ingredient_list(recipe_id))  
        new_quantity = @prompt.ask('Enter your updated quantity --> ', )
        ingredient_id = Ingredient.get_ingredient_id(ingredient)
        RecipeIngredient.find_recipe_ingredient(recipe_id, ingredient_id).update(quantity: new_quantity)
        puts "\n\n"
        puts "------------------ RECIPE UPDATED -----------------------"
        puts "\n"
        Recipe.print_recipe(recipe_name)
    end 
    

    def delete_recipe
        recipe_name = @prompt.select("Which recipe would you like to delete?", Recipe.populate_recipe_list)
        recipe_id = Recipe.get_recipe_id(recipe_name)
        Recipe.print_recipe(recipe_name)
        puts "\n"
        delete = @prompt.yes?("Are you sure you want to delete?")
        if delete == true
            Recipe.all.destroy(recipe_id)
            puts "\n\n"
            puts "------------------ RECIPE DELETED -----------------------"
            puts "\n"
        end 
        puts "\n\n"
        menu_or_exit
    end

    def menu_or_exit 
        selection = @prompt.select("What would you like to do next?\n\n", [
            "Return to main menu", 
            "Exit application\n" 
        ])
        puts "\n\n"
        selection == "Return to main menu" ? main_menu : exit_app
    end 

    def exit_app 
        puts "\n --------------- Thanks for using CALORIE COMMANDER! ----------------- \n\n"
    end 


end 