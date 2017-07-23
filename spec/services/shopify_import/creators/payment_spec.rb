require 'spec_helper'

describe ShopifyImport::Creators::Payment, type: :service do
  subject { described_class.new(shopify_data_feed, spree_order) }

  before { authenticate_with_shopify }

  describe '#save!', vcr: { cassette_name: 'shopify/base_order' } do
    let(:spree_order) { create(:order) }
    let(:shopify_order) { ShopifyAPI::Order.find(5_182_437_124) }
    let(:shopify_transaction) { shopify_order.transactions.first }
    let(:shopify_data_feed) do
      create(:shopify_data_feed,
             shopify_object_type: 'ShopifyAPI::Transaction',
             shopify_object_id: shopify_transaction.id,
             data_feed: shopify_transaction.to_json)
    end
    let(:spree_payment) { Spree::Payment.last }

    it 'creates spree payment' do
      expect { subject.save! }.to change(Spree::Payment, :count).by(1)
    end

    context 'sets payment attributes' do
      before { subject.save! }

      it 'number' do
        expect(spree_payment.number).to eq "SP#{shopify_transaction.id}"
      end

      it 'amount' do
        expect(spree_payment.amount).to eq shopify_transaction.amount.to_d
      end

      it 'state' do
        expect(spree_payment.state).to eq 'completed'
      end
    end

    context 'sets payment associations' do
      let(:payment_method) { Spree::PaymentMethod::ShopifyPayment.last }

      before { subject.save! }

      it 'order' do
        expect(spree_payment.order).to eq spree_order
      end

      it 'payment method' do
        expect(spree_payment.payment_method).to eq payment_method
      end
    end

    context 'sets payment timestamps' do
      before { subject.save! }

      it 'created at' do
        expect(spree_payment.created_at).to eq shopify_transaction.created_at.to_datetime
      end

      it 'updated at' do
        expect(spree_payment.updated_at).to eq shopify_transaction.created_at.to_datetime
      end
    end
  end
end
