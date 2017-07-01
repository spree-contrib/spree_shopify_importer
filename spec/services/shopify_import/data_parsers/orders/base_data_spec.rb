require 'spec_helper'

RSpec.describe ShopifyImport::DataParsers::Orders::BaseData, type: :service do
  let(:shopify_order) { create(:shopify_order) }
  let(:shopify_transaction) { create(:shopify_transaction, order: shopify_order) }
  subject { described_class.new(shopify_order) }

  describe '#user' do
    let(:user) { create(:user) }
    let!(:shopify_data_feed) do
      create(:shopify_data_feed,
             spree_object: user,
             shopify_object_id: shopify_order.customer.id,
             shopify_object_type: 'ShopifyAPI::Customer')
    end

    it 'returns spree user' do
      expect(subject.user).to eq user
    end

    context 'where user is not imported' do
      it 'creates new user'
    end
  end

  describe '#order_attributes' do
    let(:base_order_attributes) do
      {
        number: shopify_order.order_number,
        email: shopify_order.email,
        channel: I18n.t('shopify'),
        currency: shopify_order.currency,
        note: shopify_order.note,
        confirmation_delivered: shopify_order.confirmed,
        last_ip_address: shopify_order.browser_ip,
        item_count: shopify_order.line_items.sum(&:quantity)
      }
    end
    let(:order_totals) do
      {
        total: shopify_order.total_price,
        item_total: shopify_order.total_line_items_price,
        additional_tax_total: shopify_order.total_tax,
        promo_total: -shopify_order.total_discounts.to_d,
        payment_total: shopify_transaction.amount,
        shipment_total: shopify_order.shipping_lines.sum(&:price)
      }
    end
    let(:order_states) do
      {
        state: 'complete',
        payment_state: 'paid',
        shipment_state: 'shipped'
      }
    end
    let(:result) do
      [base_order_attributes, order_totals, order_states].inject(&:merge)
    end

    before do
      allow_any_instance_of(ShopifyAPI::Order).to receive(:transactions).and_return([shopify_transaction])
    end

    it 'prepare hash of order attributes' do
      expect(subject.order_attributes).to eq result
    end

    context 'other order states'
  end

  context '#order_timestamps' do
    let(:order_timestamps) do
      {
        created_at: shopify_order.created_at,
        updated_at: shopify_order.updated_at
      }
    end

    it 'prepare hash of order timestamps' do
      expect(subject.order_timestamps).to eq order_timestamps
    end
  end
end
