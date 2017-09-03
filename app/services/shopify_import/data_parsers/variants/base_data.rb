module ShopifyImport
  module DataParsers
    module Variants
      class BaseData
        def initialize(shopify_variant, spree_product)
          @shopify_variant = shopify_variant
          @spree_product = spree_product
        end

        def attributes
          @attributes ||= {
            sku: @shopify_variant.sku,
            price: @shopify_variant.price,
            weight: @shopify_variant.grams,
            position: @shopify_variant.position,
            product_id: @spree_product.id
          }
        end

        def option_value_ids
          @option_value_ids ||= %w[option1 option2 option3].map do |option_name|
            next unless (option_value = @shopify_variant.send(option_name))

            Spree::OptionValue.find_by!(
              option_type_id: @spree_product.option_type_ids,
              name: option_value.strip.downcase
            ).id
          end
        end

        def track_inventory?
          @track_inventory ||= @shopify_variant.inventory_management.eql?('shopify')
        end

        def backorderable?
          @backorderable ||= @shopify_variant.inventory_policy.eql?('continue')
        end

        def inventory_quantity
          @inventory_quantity ||= @shopify_variant.inventory_quantity
        end

        def stock_location
          @stock_location ||=
            Spree::StockLocation.create_with(default: false, active: false).find_or_create_by(name: I18n.t(:shopify))
        end
      end
    end
  end
end
