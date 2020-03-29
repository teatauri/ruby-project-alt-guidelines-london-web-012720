class Api 

    def self.call_api(name, ingredients)
        ingredientArray = ingredients.join.delete('--->').split(/\n/)
        body = { "title": name, "ingr": ingredientArray }.to_json
        response = RestClient.post(
            "https://api.edamam.com/api/nutrition-details?app_id=2f6b3adf&app_key=01bac796edcb5cb7823a8de1c2830769",
            body,
            { content_type: :json },
        )
        info = JSON.parse(response)
        puts "Your recipe contains #{info['calories']} calories."
        puts "\n\n"
        puts "------------------------------------------------------------"
    end 

end 