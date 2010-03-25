module BigFileParser
  module CSV
    
    class Parser
      attr_reader :elements
      
      def initialize(klass,file,header=true)
        unless klass.respond_to?('_is_csv_parser?')
          raise(BigFileParserError, 'BigFileParser::CSV::Properties Required')
        end
        @file = file
        @object = klass
        @header = header
        @elements = []
        @csv_properties = klass._csv_properties
      end
      
      def run
        stream { |element| elements << element }
        elements
      end

      def stream(&block)
        ::CSV.foreach(@file, {:headers => @header}) do |row|
          element = @object.new
          @csv_properties.each do |property|
            result = row[property.location]
            result = result.blank? ? nil : result
            element.send("#{property.name}=",result)
          end
          yield element
        end
      end
      
      protected
      def result_or_nil(result)
        result.blank? ? nil : result
      end
      
    end # Parser
    
  end # XML
end # BigFileParser