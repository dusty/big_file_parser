module BigFileParser
  module CSV
    module Properties

      class CSVProperty
        attr_reader :name, :location
        def initialize(name,location)
          @name = name.to_s.downcase
          @location = location.to_i
        end
      end
      
      def self.included(base)
        base.instance_variable_set(:@csv_properties,[])
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
      end
      
      module ClassMethods
        
        ##
        # Parse an csv file
        #
        # @return [Array<Object>] an array of objects
        # @see BigFileParser::CSV::Parser
        def parse_file(file)
          parser = BigFileParser::CSV::Parser.new(file,csv)
          parser.run
        end

        ##
        # Make sure this class is a big_file_parser compatible class
        def _is_csv_parser?
          true
        end
        
        def _csv_properties
          @csv_properties
        end
        
        def property(name,location)
          _csv_properties << CSVProperty.new(name,location)
          send(:attr_accessor, name)
        end
        
      end # ClassMethods
      
      module InstanceMethods
        def method_missing(*args)
          nil
        end
      end
      
    end # Properties
    
  end # CSV
end # BigFileParser