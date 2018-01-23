require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::CustomerReturns::CustomerReturnCreator, type: :service do
  subject { described_class.new(shopify_refund) }

  before { authenticate_with_shopify }

  describe '#create' do
    context 'with base shopify refund data', vcr: { cassette_name: 'shopify/base_refund' } do
      let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }

      it 'creates customer refund' do
        expect { subject.create }.to change(Spree::CustomerReturn, :count).by(1)
      end

      context 'attributes' do
        let(:spree_customer_return) { subject.create }

        it 'number' do
          expect(spree_customer_return.number).to eq 'SCR225207300'
        end
      end

      context 'associations' do
        let(:spree_customer_return) { subject.create }
        let(:stock_location) { Spree::StockLocation.find_by!(name: I18n.t(:shopify)) }

        it 'stock location' do
          expect(spree_customer_return.stock_location).to eq stock_location
        end
      end

      context 'timestamps' do
        let(:spree_customer_return) { subject.create }

        it 'created at' do
          expect(spree_customer_return.created_at).to eq shopify_refund.created_at
        end

        it 'updated at' do
          expect(spree_customer_return.updated_at).to eq shopify_refund.processed_at
        end
      end
    end
  end
end
