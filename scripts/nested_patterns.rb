require "./models/item"

size_factor_range     = 0.05..0.2

10.times do |i|
  Item.new(template: :phone_case,
           nested_pattern: {size_factor: Random.new.rand(size_factor_range)},
           file_name: "nested_pattern_#{i}")

end
