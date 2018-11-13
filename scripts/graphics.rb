require "./models/item"

la_things = ["Lebron", "Beach", "Coding", "Ruby", "Sun", "Tree", "Traffic", "Movies"]

la_things.each do |name|
  Item.new(template: :phone_case,
           icon: name,
           file_name: name.gsub(" ", ""))
end
