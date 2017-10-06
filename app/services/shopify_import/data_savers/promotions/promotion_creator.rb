module ShopifyImport
  module DataSavers
    module Promotions
      class PromotionCreator < BaseDataSaver
        delegate :attributes, :expires_at, to: :parser

        def initialize(spree_order, shopify_discount_code)
          @spree_order = spree_order
          @shopify_discount_code = shopify_discount_code
        end

        def create!
          Spree::Promotion.transaction do
            create_promotion
          end
        end

        private

        def create_promotion
          @spree_promotion =
            Spree::Promotion.create_with(expires_at: Time.current).find_or_create_by!(attributes)
        end

        def parser
          @parser ||= ShopifyImport::DataParsers::Promotions::BaseData.new(@shopify_discount_code)
        end
      end
    end
  end
end
