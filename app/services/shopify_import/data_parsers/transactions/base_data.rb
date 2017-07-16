module ShopifyImport
  module DataParsers
    module Transactions
      class BaseData
        class InvalidStatus < ::StandardError; end

        def initialize(shopify_transaction)
          @shopify_transaction = shopify_transaction
        end

        def payment_number
          "SP#{@shopify_transaction.id}"
        end

        def payment_attributes
          {
            amount: @shopify_transaction.amount,
            state: payment_state,
            payment_method: payment_method
          }
        end

        def payment_timestamps
          {
            created_at: @shopify_transaction.created_at.to_datetime,
            updated_at: @shopify_transaction.created_at.to_datetime
          }
        end

        private

        def payment_state
          return :void unless %i[authorization capture sale].include?(@shopify_transaction.kind.to_sym)

          select_state
        end

        def select_state
          case (status = @shopify_transaction.status.to_sym)
          when :pending then :pending
          when :failure, :error then :failed
          when :success then :completed
          else
            raise InvalidStatus, I18n.t('errors.transaction.no_payment_state', status: status)
          end
        end

        def payment_method
          Spree::PaymentMethod
            .create_with(active: false)
            .find_or_create_by(name: @shopify_transaction.gateway, type: 'Spree::PaymentMethod::ShopifyPayment')
        end
      end
    end
  end
end
