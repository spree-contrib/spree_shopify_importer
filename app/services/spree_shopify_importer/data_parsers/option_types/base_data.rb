module SpreeShopifyImporter
  module DataParsers
    module OptionTypes
      class BaseData
        def initialize(option_type)
          @option_type = option_type
        end

        def attributes
          {
            name: name,
            presentation: @option_type.name
          }
        end

        def name
          @name ||= @option_type.name.downcase
        end

        def shopify_values
          @option_type.values.compact
        end
      end
    end
  end
end
