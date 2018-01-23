module SpreeShopifyImporter
  module DataParsers
    module ReturnItems
      class BaseData
        def initialize(shopify_refund_line_item, shopify_refund, spree_return_authorization, spree_inventory_unit)
          @shopify_refund_line_item = shopify_refund_line_item
          @shopify_refund = shopify_refund
          @spree_return_authorization = spree_return_authorization
          @spree_inventory_unit = spree_inventory_unit
        end

        # TODO: map to proper statuses
        def attributes
          @attributes ||= {
            pre_tax_amount: pre_tax_amount,
            additional_tax_total: additional_tax_total,
            resellable: false,
            acceptance_status: :accepted,
            reception_status: :received,
            preferred_reimbursement_type: preferred_reimbursement_type,
            return_authorization: @spree_return_authorization,
            inventory_unit: @spree_inventory_unit
          }
        end

        def timestamps
          @timestamps ||= {
            created_at: @shopify_refund.created_at.to_datetime,
            updated_at: @shopify_refund.processed_at.try(:to_datetime)
          }
        end

        private

        def pre_tax_amount
          @shopify_refund_line_item.line_item.price.to_d
        end

        def additional_tax_total
          (@shopify_refund_line_item.total_tax / @shopify_refund_line_item.quantity).round(2).to_d
        end

        def preferred_reimbursement_type
          Spree::ReimbursementType.create_with(active: 'false').find_or_create_by(name: I18n.t(:shopify))
        end
      end
    end
  end
end
