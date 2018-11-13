class Template
  attr_accessor :name, :size

  def initialize(name, size)
    @name             = name
    @size             = size
  end

  def self.load(name)
    all.detect{|t| t.name == name}
  end

  def self.all
    [ Template.new(:notebook,      [5.25.in, 8.in]),
      Template.new(:phone_case,    [3.in, 5.75.in]),
      Template.new(:laptop_sleeve, [13.in, 8.in]) ]
  end
end
