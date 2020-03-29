#calories per 100g
calories = {"meat" => 200, "carrots" => 50, "potatoes" => 100, "onions" => 20, "garlic" => 10}


def calculate_calories(ingredient_id, grams, calories)
  ingredient = calories.each.find {|k, v| k == ingredient_id}
  ratio = (100 / grams.to_f)
  cals = ingredient[1] / ratio
  cals
end

calculate_calories("meat", 60, calories)

#####################################################################

recipe = {"meat" => 35, "carrots" => 20, "potatoes" => 50}

def recipe_calories(recipe, calories)
  recipe_calories = []
  recipe.each do |ingredient, grams|
    recipe_calories << calculate_calories(ingredient, grams, calories)
  end
  recipe_calories.reduce(:+)
end

p recipe_calories(recipe, calories)
