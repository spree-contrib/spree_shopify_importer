module ShopifyImport
  module DataParsers
    module ShippingRates
      class BaseData
        def initialize(shopify_shipping_line, shopify_order)
          @shopify_shipping_line = shopify_shipping_line
          @shopify_order = shopify_order
        end

        def shipping_rate_attributes
          {
            selected: true,
            shipping_method: shipping_method,
            cost: shipping_cost
          }
        end

        private

        def shipping_method
          method = find_or_create_shipping_method
          return method if method.calculator.present?

          add_calculator_to_shipping_method(method)
          method
        end

        def add_calculator_to_shipping_method(method)
          method.update_attribute(:calculator, find_or_create_calculator(method))
        end

        def find_or_create_calculator(method)
          Spree::Calculator::Shipping::Shopify.find_or_create_by!(calculable: method)
        end

        def find_or_create_shipping_method
          method = Spree::ShippingMethod
                   .create_with(shipping_method_attributes)
                   .find_or_initialize_by(name: shipping_method_code, display_on: :back_end)
          method.save(validate: false)
          method
        end

        def shipping_method_attributes
          { zones: Spree::Zone.all, shipping_categories: Spree::ShippingCategory.all, code: shipping_method_code }
        end

        def shipping_method_code
          @shipping_method_code ||= @shopify_shipping_line.code || I18n.t('shopify')
        end

        def shipping_cost
          @shopify_shipping_line.price || calculate_shipping_cost
        end

        def calculate_shipping_cost
          @shopify_order.total_price.to_d - @shopify_order.subtotal_price.to_d - @shopify_order.total_tax.to_d
        end
      end
    end
  end
end
