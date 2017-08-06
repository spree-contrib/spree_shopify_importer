module ShopifyImport
  module Creators
    module Adjustments
      class PromotionCreator
        def initialize(spree_order, spree_promotion, shopify_discount_code)
          @spree_order = spree_order
          @spree_promotion = spree_promotion
          @shopify_discount_code = shopify_discount_code
        end

        def save!
          Spree::Adjustment.transaction do
            create_adjustment
          end
          update_timestamps
        end

        private

        def create_adjustment
          @spree_adjustment = @spree_order.adjustments.create!(adjustment_attributes)
        end

        def update_timestamps
          @spree_adjustment.update_columns(adjustment_timestamps)
        end

        def adjustment_attributes
          parser.adjustment_attributes
        end

        def adjustment_timestamps
          parser.adjustment_timestamps
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::Adjustments::Promotions::BaseData.new(
            @spree_order, @spree_promotion, @shopify_discount_code
          )
        end
      end
    end
  end
end
