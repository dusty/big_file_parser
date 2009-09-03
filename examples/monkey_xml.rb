class Monkey
  include BigFileParser::XML::Properties
  element :monkey
  property :id, :attribute, :element => :monkey

  property :name, :text

  property :age, :text, :element => :yrsold
        
  property :funny, :attribute, :element => :personality, 
          :attribute => :hilarious
        
  property :loud, :text, :element => :personality
        
  property :street, :text

  property :city, :text

  property :state, :text

  property :zip, :text

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

#m = BigFileParser::XML::Parser.new(Monkey,'monkeys.xml')
#m.run
#puts "Parsed #{m.elements.length} elements"
#puts "  First Element Name: #{m.elements.first.name}"
#puts "  Last Element Name: #{m.elements.last.name}"

