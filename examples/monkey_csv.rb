class Monkey
  include BigFileParser::CSV::Properties

  property :id, 0

  property :name, 1

  property :age, 2
        
  property :funny, 3
        
  property :loud, 4
        
  property :street, 5

  property :city, 6

  property :state, 7

  property :zip, 8

  def address
    [street, city, state].compact.join(", ") + " #{zip}"
  end
  
  def age
    @age.to_i
  end

  def funny=(value)
    @funny = (value == "true" ? true : false)
  end
end

#m = BigFileParser::CSV::Parser.new(Monkey,'monkeys.csv')
#m.run
#puts "Parsed #{m.elements.length} elements"
#puts "  First Element Name: #{m.elements.first.name}"
#puts "  Last Element Name: #{m.elements.last.name}"

