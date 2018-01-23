module SpreeShopifyImporter
  module DataSavers
    module OptionTypes
      class OptionTypeCreator
        delegate :name, :attributes, :shopify_values, to: :parser

        def initialize(shopify_option_type)
          @shopify_option_type = shopify_option_type
        end

        def create!
          Spree::OptionType.transaction do
            @spree_option_type = find_or_create_option_type
            shopify_values.each do |value|
              SpreeShopifyImporter::DataSavers::OptionValues::OptionValueCreator.new(value, @spree_option_type).create!
            end
          end
          @spree_option_type
        end

        private

        def find_or_create_option_type
          Spree::OptionType.where('lower(name) = ?', name).first_or_create!(attributes)
        end

        def parser
          @parser ||= SpreeShopifyImporter::DataParsers::OptionTypes::BaseData.new(@shopify_option_type)
        end
      end
    end
  end
end
