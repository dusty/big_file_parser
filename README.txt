== DESCRIPTION:

Used to parse large XML or CSV files.


== REQUIREMENTS:

libxml-ruby
fastercsv


== INSTALL:

$ gem build big_file_parser.gemspec
$ sudo gem install big_file_parser-x.x.x.gem


== USAGE:

Say you have an xml document like below.  We are interested in extracting
the Monkey elements out of it.

XML::PARSER

<xml>
  <animals>
    <elephant id="3">
      <name>elephant1</name>
      <trunk>large</trunk>
    </elephant>
    <monkey id="1">
      <name>monkey1</name>
      <yrsold>23</yrsold>
      <personality hilarious="true">quiet</personality>
      <street>300 Monkey St</street>
      <city>Cincinnati</city>
      <state>Oh</state>
      <zip>45219</zip>
    </monkey>
    <monkey id="2">
      <name>monkey2</name>
      <yrsold>33</yrsold>
      <personality hilarious="false">loud</personality>
      <street>301 Monkey St</street>
      <city>Cincinnati</city>
      <state>Oh</state>
      <zip>45219</zip>
    </monkey>
  </animals>
</xml>

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

# Load the parser, with the Monkey class and an XML File
m = BigFileParser::XML::Parser.new(Monkey,'examples/monkeys.xml')

# Run the parser
m.run
=> true

# Inspect the first element
m.elements.first.class
=> Monkey
m.elements.first.id
=> "1"
m.elements.first.name
=> "monkey1"
m.elements.first.age
=> 23
m.elements.first.funny
=> true
m.elements.first.loud
=> "quiet"
m.elements.first.address
=> "300 Monkey St, Cincinnati, Oh 45219"

# Inspect the last element
m.elements.last.class
=> Monkey
m.elements.last.id
=> "2"
m.elements.last.name
=> "monkey2"
m.elements.last.age
=> 33
m.elements.last.funny
=> false
m.elements.last.loud
=> "loud"
m.elements.last.address
=> "301 Monkey St, Cincinnati, Oh 45219"


CSV::PARSER

CSV Files are handled similarly.

id,name,age,funny,loud,street,city,state,zip
1,monkey1,23,true,quiet,300 Monkey St,Cincinnati,Oh,45219
2,monkey2,33,false,loud,301 Monkey st,Cincinnati,Oh,45219

m = BigFileParser::CSV::Parser.new(Monkey,'examples/monkeys.csv')

# Run the parser
m.run
=> true

# Inspect the first element
m.elements.first.class
=> Monkey
m.elements.first.address
=> "300 Monkey St, Cincinnati, Oh 45219"

pp m.elements.first
#<Monkey:0x141a54
 @age="23",
 @city="Cincinnati",
 @funny=true,
 @id="1",
 @loud="quiet",
 @name="monkey1",
 @state="Oh",
 @street="300 Monkey St",
 @zip="45219">
=> nil

pp m.elements.last
#<Monkey:0x112538
 @age="33",
 @city="Cincinnati",
 @funny=false,
 @id="2",
 @loud="loud",
 @name="monkey2",
 @state="Oh",
 @street="301 Monkey st",
 @zip="45219">



XML::INSPECTOR

In addition, there is an Inspector class which will inspect an xml document
and tell you the types of properties that are within the document.  This
is especially helpful, if you do not have an XML schema and have a large
document that you are trying to understand.

The Inspector will run through the entire document to find all elements
or attributes that are ever declared inside the document.

# Load the inspector, passing the element name you are interested in
# and the xml document
m = BigFileParser::XML::Inspector.new(:monkey,'examples/monkeys.xml')

# Run the inspector and take a look at the output
m.run

element :monkey
property :hilarious, :attribute, :element => :personality
property :id, :attribute, :element => :monkey
property :city, :text
property :name, :text
property :personality, :text
property :state, :text
property :street, :text
property :yrsold, :text
property :zip, :text


CSV::INSPECTOR

The CSV inspector requires that the CSV file has a header row.  If it
does it will simply read in the first line of the file and output the
possible properties, similar to the XML::Inspector

m = BigFileParser::CSV::Inspector.new('examples/monkeys.csv')
m.run

property :id, 0
property :name, 1
property :age, 2
property :funny, 3
property :loud, 4
property :street, 5
property :city, 6
property :state, 7
property :zip, 8



== FEATURES/PROBLEMS:

Only one element per class right now.

Only supports UTF-8.  If you are having problems with an XML
document, try removing the invalid characters.
$ iconv -f UTF-8 -t UTF-8 -c infile.xml > outfile.xml

require 'shell_command'
begin
  puts "Parsing XML file"
  m = BigFileParser::XML::Parser.new(Listing,'/tmp/20090303_Listings.xml')
  m.run
rescue LibXML::XML::Error
  puts "Exception Caught Fixing Encoding"
  command = ShellCommand.new('iconv -f UTF-8 -t UTF-8 -c')
  file = "/tmp/#{Time.now.to_i}_listings.xml"
  command.run("20090303_Listings.xml > #{file}")
  m = BigFileParser::XML::Parser.new(Listing,file)
  puts "Re-Parsing XML File"
  m.run
end


== LICENSE:

(The MIT License)

Copyright (c) 2008 FIX

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
