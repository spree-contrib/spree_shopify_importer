module SpreeShopifyImporter
  module DataParsers
    module Adjustments
      module Promotions
        class BaseData
          def initialize(spree_order, spree_promotion, shopify_discount_code)
            @spree_order = spree_order
            @spree_promotion = spree_promotion
            @shopify_discount_code = shopify_discount_code
          end

          def attributes
            @attributes ||= {
              source: action,
              order: @spree_order,
              amount: amount,
              state: :closed,
              label: @shopify_discount_code.code,
              adjustable: @spree_order
            }
          end

          def timestamps
            @timestamps ||= {
              created_at: @spree_order.created_at,
              updated_at: @spree_order.created_at
            }
          end

          private

          # TODO: calculate percent amount
          def amount
            - @shopify_discount_code.amount.to_d
          end

          def action
            Spree::Promotion::Actions::CreateAdjustment
              .create_with(calculator: calculator)
              .find_or_create_by(promotion: @spree_promotion)
          end

          def calculator
            return if (type = @shopify_discount_code.type).blank?

            create_calculator(type)
          end

          def create_calculator(type)
            case type.to_sym
            when :fixed_amount
              Spree::Calculator::FlatRate.create(preferred_amount: @shopify_discount_code.amount)
            when :percentage
              Spree::Calculator::FlatPercentItemTotal.create(preferred_flat_percent: @shopify_discount_code.amount)
            when :shipping
              Spree::Calculator::FreeShipping.create
            else
              raise NotImplementedError
            end
          end
        end
      end
    end
  end
end
