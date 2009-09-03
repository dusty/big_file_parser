module BigFileParser
  module CSV
    
    class Inspector
      def initialize(file)
        @file = file
        @properties = []
      end
      
      def run
        line = File.open(@file,'r') do |f|
          f.readline
        end
        ::CSV.parse_line(line).each_with_index do |name,index|
          puts "property :#{name}, #{index}"
        end
        true
      end
    
    end # Inspector
    
  end # CSV
end # BigFileParser