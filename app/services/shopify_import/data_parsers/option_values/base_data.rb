module ShopifyImport
  module DataParsers
    module OptionValues
      class BaseData
        def initialize(value)
          @value = value.strip
        end

        def attributes
          {
            name: name,
            presentation: @value
          }
        end

        def name
          @name ||= @value.downcase
        end
      end
    end
  end
end
