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
        arr = []
        self.all.find do |recipe| 
            if recipe.name.downcase == name.downcase  
                recipe_id = recipe.id
                list = RecipeIngredient.all.select {|e| e.recipe_id == recipe_id}.map {|e| ["#{e.ingredient_name} ---> ", "#{e.quantity}\n"]}
                puts "Your recipe for #{name.upcase} is as follows -->\n\n"
                arr << list
                puts arr
                puts "\n------------------------------------------------------------"
            end 
        end  
        self.call_api(name, arr)  # need to pass arr to API to get back info
    end 

    def self.call_api(name, arr)
        # The request must contain the header - Content-Type: application/json
        require 'net/http'
        require 'json'
        arr = arr.join.split(/\n/)
        # recipe = {
        #     "title": name,
        #     "ingr": arr 
        # }.to_json
        #'https://api.edamam.com/api/nutrition-details?app_id=2f6b3adf&app_key=01bac796edcb5cb7823a8de1c2830769'

        begin
            uri = URI('https://api.edamam.com/api/nutrition-details')
            http = Net::HTTP.new(uri.host, uri.port)
            req = Net::HTTP::Post.new(uri.path, {'Content-Type' => 'application/json',
                'Authorization' => 'https://api.edamam.com/api/nutrition-details?app_id=2f6b3adf&app_key=01bac796edcb5cb7823a8de1c2830769'})
            req.body = {"title": name, "ingr": arr }.to_json
            res = http.request(req)
            puts "response #{res.body}"
            puts JSON.parse(res.body)
        rescue => e
            puts "failed #{e}"
        end

        # response = RestClient.get(recipe -H "Content-Type: application/json" "https://api.edamam.com/api/nutrition-details?app_id=2f6b3adf&app_key=01bac796edcb5cb7823a8de1c2830769")
        # parsed = JSON.parse response
        # puts parsed
    end 

    def self.populate_recipe_list 
        self.list_recipes.sort.split
    end 

    def self.get_recipe_id(name)
        recipe_id = self.all.find {|recipe| recipe.name == name}.id
    end 

end


