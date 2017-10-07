module ShopifyImport
  module DataParsers
    module LineItems
      class VariantNotFound < StandardError; end

      class BaseData
        def initialize(shopify_line_item, shopify_order)
          @shopify_line_item = shopify_line_item
          @shopify_order = shopify_order
        end

        def line_item_attributes
          {
            quantity: @shopify_line_item.quantity,
            price: @shopify_line_item.price,
            currency: @shopify_order.currency,
            adjustment_total: - @shopify_line_item.total_discount.to_d
          }
        end

        def variant
          return nil if (variant_id = @shopify_line_item.variant_id).blank?

          @variant ||= find_variant(variant_id)

          return @variant if @variant.present?

          handle_missing_variant_exception
        end

        private

        def find_variant(variant_id)
          Shopify::DataFeed.find_by(shopify_object_type: 'ShopifyAPI::Variant',
                                    shopify_object_id: variant_id).try(:spree_object)
        end

        def handle_missing_variant_exception
          product_id = @shopify_line_item.product_id
          shopify_product = ShopifyAPI::Product.find(product_id)
          ShopifyImport::Importers::ProductImporterJob.perform_later(shopify_product.to_json)

          variant_id = @shopify_line_item.variant_id
          raise VariantNotFound, I18n.t('errors.line_items.no_variant_found', variant_id: variant_id)
        end
      end
    end
  end
end
