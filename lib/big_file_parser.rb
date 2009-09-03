#http://libxml.rubyforge.org/rdoc/classes/LibXML/XML/Reader.html
require 'rubygems'
require 'libxml'
if RUBY_VERSION > "1.9"
  require 'csv'
else
  require 'fastercsv'
  CSV = FasterCSV
end

module BigFileParser
  
  class BigFileParserError < StandardError; end
  
  def self.version
    "0.0.5"
  end
  
end
require File.join(File.expand_path(
  File.dirname(__FILE__)), 'xml', 'properties'
)
require File.join(File.expand_path(
  File.dirname(__FILE__)), 'xml', 'parser'
)
require File.join(File.expand_path(
  File.dirname(__FILE__)), 'xml', 'inspector'
)
require File.join(File.expand_path(
  File.dirname(__FILE__)), 'csv', 'properties'
)
require File.join(File.expand_path(
  File.dirname(__FILE__)), 'csv', 'parser'
)
require File.join(File.expand_path(
  File.dirname(__FILE__)), 'csv', 'inspector'
)