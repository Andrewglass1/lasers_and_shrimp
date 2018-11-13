require "./models/item"

type_options          = [:square, :triangle]
size_factor_range     = 0.05..0.2
fill_factor_range     = 0.3..0.6
omission_factor_range = 0.05..0.2
punch_factor_range    = 0.15..0.4


10.times do |i|
  Item.new(template: :phone_case,
           pattern: {type:            type_options.sample,
                     size_factor:     Random.new.rand(size_factor_range),
                     fill_factor:     Random.new.rand(fill_factor_range),
                     omission_factor: Random.new.rand(omission_factor_range),
                     punch_factor:    Random.new.rand(punch_factor_range),
                   },
           file_name: "test_pattern_#{i}")
end
