require 'tty-prompt'
require 'tty-box'
require 'catpix'

class CLI

    def initialize
        @prompt = TTY::Prompt.new
    end
  
    def start
        # Catpix::print_image "./recipe.jng",
        # :limit_x => 1.0,
        # :limit_y => 0,
        # :center_x => true,
        # :center_y => true,
        # :bg => "white",
        # :bg_fill => true,
        # :resolution => "low"
        puts "                                                                             
    =============================== The Calorie-Counter ==================================                                                                      
                                                                                                        
        "
        main_menu
    end
    
    def main_menu
        selection = @prompt.select("------------ MAIN MENU -----------", [
            "Create a new recipe", 
            "View an existing recipe", 
            "Update a recipe", 
            "Delete a recipe \n\n\n\n"
        ])

        if selection == "Create a new recipe"
            new_recipe 
        elsif selection == "View an existing recipe"
            view_existing_recipe 
        elsif selection == "Update a recipe" 
            update_recipe 
        else 
            delete_recipe 
        end 
    end

    def new_recipe 
        recipe_name = @prompt.ask('What would you like to call this recipe? -->')
        Recipe.create_recipe(recipe_name)
        recipe_id = Recipe.get_recipe_id(recipe_name)
        ingredient_array = add_ingredients(recipe_id)
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
    end 

    def view_existing_recipe
        puts "\n\n"
        puts "------------------------------------------------------------"
        puts "\n"
        selection = @prompt.select("What did you have in mind?\n", [
            "Search for a specific recipe", 
            "View all my recipes" 
        ])
        selection == "Search for a specific recipe" ? search_specific_recipe : view_all_recipes
        menu_or_exit 
    end 

    def search_specific_recipe
        puts "\n"
        recipe_name = @prompt.ask("Which recipe would you like to view?")
        puts "\n"
        Recipe.print_recipe(recipe_name)
    end 

    def view_all_recipes
        puts "\n"
        recipe_name = @prompt.select("Select a recipe ", Recipe.populate_recipe_list)
        puts "\n"
        Recipe.print_recipe(recipe_name)
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
        quantity = @prompt.ask("What quantity of #{ingredient} will you use? --> ")
        ingredient_id = Ingredient.get_ingredient_id(ingredient)
        RecipeIngredient.create_recipe_ingredient(recipe_id, ingredient_id, ingredient, quantity)
        puts "\n"
        puts "------------------ RECIPE UPDATED -----------------------\n"
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
        selection = @prompt.select("What would you like to do next?", [
            "Return to main menu", 
            "Exit application\n" 
        ])
        selection == "Return to main menu" ? main_menu : exit_app
    end 

    def exit_app 
        puts "\n --------------- Thanks for using CALORIE COMMANDER! ----------------- \n\n"
    end 


end 