module BigFileParser
  module XML
    
    class Inspector
      def initialize(element,file)
        @reader = LibXML::XML::Reader.file(file)
        @element_name = element.to_s.downcase
        @text_properties = []
        @attribute_properties = []
        @target_element = false
      end
      
      def run
        parse while @reader.read
        print_results
      end
      
      def print_results
        puts "element :#{@element_name.to_sym}"
        print_attribute_properties
        print_text_properties
        true
      end
      
      def print_attribute_properties
        @attribute_properties.sort.each do |attr_prop|
          puts "property :#{attr_prop[0]}, :attribute, :element => :#{attr_prop[1]}"
        end
      end
      
      def print_text_properties
        @text_properties.sort.each do |text_prop|
          puts "property :#{text_prop}, :text"
        end
      end
      
      protected
      def parse
        case @reader.node_type
        when LibXML::XML::Reader::TYPE_ELEMENT
          @current_node = @reader.name.downcase
          mark_target_element
          parse_element
          parse_attributes
        when LibXML::XML::Reader::TYPE_END_ELEMENT
          unmark_target_element
        end
      end
      
      def parse_element
        if target_element?
          add_text_property(@reader.name)
        end
      end
      
      def parse_attributes
        if target_element?
          while @reader.move_to_next_attribute > 0
            add_attribute_property(@reader.name,@current_node)
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
      
      def add_attribute_property(name,element)
        attribute_property = [name.to_s.downcase,element.to_s.downcase]
        unless @attribute_properties.include?(attribute_property)
          @attribute_properties << attribute_property
        end
      end
      
      def add_text_property(name)
        unless name.to_s.downcase == @element_name
          unless @text_properties.include?(name.to_s.downcase)
            @text_properties << name.to_s.downcase
          end
        end
      end
      
    end # Inspector
    
  end # XML
end # BigFileParser