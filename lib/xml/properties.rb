module BigFileParser
  module XML
    module Properties
      
      class TextProperty
        attr_reader :name, :element
        
        def initialize(name,element)
          @name = name.to_s.downcase
          @element = element.to_s.downcase
        end
        
      end
      
      class AttributeProperty
        attr_reader :name, :element, :attribute
        
        def initialize(name,element,attribute)
          @name = name.to_s.downcase
          @element = element.to_s.downcase
          @attribute = attribute.to_s.downcase
        end
        
      end
      
      def self.included(base)
        base.instance_variable_set(:@text_properties,[])
        base.instance_variable_set(:@attribute_properties,[])
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        
        ##
        # Parse an xml file
        #
        # @return [Array<Object>] an array of objects
        # @see BigFileParser::XML::Parser
        def parse_file(file)
          parser = BigFileParser::XML::Parser.new(self,file)
          parser.run
        end

        ##
        # Make sure this class is a big_file_parser compatible class
        def _is_xml_parser?
          true
        end
        
        def _text_properties
          @text_properties
        end
        
        def _attribute_properties
          @attribute_properties
        end
        
        def _element_name
          @element_name
        end
        
        def element(name)
          @element_name = name.to_s.downcase
        end
        
        def property(name,type,opts={})
          case type
          when :text
            element = (opts[:element] || name)
            _add_text_property(name,element)
          when :attribute
            attribute = (opts[:attribute] || name)
            _add_attribute_property(name,opts[:element],attribute)
          else
            raise Exception.new("Must define :text or :attribute on #{name}")
          end
        end
        
        protected 
        def _add_text_property(name,element)
          _text_properties << TextProperty.new(name,element)
          send(:attr_accessor, name)
        end
        
        def _add_attribute_property(name,element,attribute)
          _attribute_properties << AttributeProperty.new(
            name,element,attribute
          )
          send(:attr_accessor, name)
        end
        
      end # ClassMethods
      
      module InstanceMethods
        
        def method_missing(*args)
          nil
        end
        
      end
      
    end # Properties
  end # XML
end # BigFileParser