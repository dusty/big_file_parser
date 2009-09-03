module BigFileParser
  module XML
    
    class Parser
      attr_reader :elements
      
      def initialize(klass,file)
        unless klass.respond_to?('_is_xml_parser?')
          raise(BigFileParserError, 'BigFileParser::XML::Properties Required')
        end
        @reader = LibXML::XML::Reader.file(file)
        @object = klass
        @elements = []
        @element_name = klass._element_name
        @text_properties = klass._text_properties
        @attribute_properties = klass._attribute_properties
        @target_element = false
      end
      
      def run
        parse while @reader.read
        @elements
      end
      
      protected
      def parse
        case @reader.node_type
        when LibXML::XML::Reader::TYPE_ELEMENT
          @current_node = @reader.name.downcase
          mark_target_element
          parse_element
        when LibXML::XML::Reader::TYPE_TEXT
          parse_text
        when LibXML::XML::Reader::TYPE_END_ELEMENT
          parse_end_element
          unmark_target_element
        end
      end
      
      def parse_element
        if target_element?
          build_element
          extract_attribute_properties
        end
      end
      
      def parse_text
        if target_element?
          extract_text_properties
        end
      end
      
      def parse_end_element
        if @reader.name.downcase == @element_name
          @elements << @current_element
        end
      end
      
      def build_element
        if @reader.name.downcase == @element_name
          @current_element = @object.new
        end
      end
      
      def extract_text_properties
        @text_properties.each do |property|
          if @current_node == property.element.downcase
            @current_element.send("#{property.name}=",@reader.value)
          end
        end
      end
      
      def extract_attribute_properties
        @attribute_properties.each do |property|
          if @current_node == property.element.downcase
            @current_element.send(
              "#{property.name}=",@reader[property.attribute]
            )
          end
        end
      end
      
      def mark_target_element
        if @reader.name.downcase == @element_name
          @target_element = true 
        end
      end
      
      def unmark_target_element
        if @reader.name.downcase == @element_name
          @target_element = false 
        end
      end
      
      def target_element?
        @target_element
      end
      
    end # Parser
    
  end # XML
end # BigFileParser