require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::ReturnAuthorizations::ReturnAuthorizationCreator, type: :service do
  let(:spree_order) { create(:order) }
  subject { described_class.new(shopify_data_feed, spree_order) }

  before { authenticate_with_shopify }

  describe '#create' do
    context 'with basic return authorization data', vcr: { cassette_name: 'shopify/base_refund' } do
      let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }
      let(:shopify_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: shopify_refund.id,
               shopify_object_type: 'ShopifyAPI::Refund',
               data_feed: shopify_refund.to_json)
      end

      it 'creates return authorization' do
        expect { subject.create }.to change(Spree::ReturnAuthorization, :count).by(1)
      end

      it 'assigns data feed to return authorization' do
        return_authorization = subject.create

        expect(shopify_data_feed.reload.spree_object).to eq return_authorization
      end

      context 'sets return authorization attributes' do
        let(:spree_return_authorization) { subject.create }

        it 'number' do
          expect(spree_return_authorization.number).to eq "SRE#{shopify_refund.id}"
        end

        it 'state' do
          expect(spree_return_authorization.state).to eq 'authorized'
        end

        it 'memo' do
          expect(spree_return_authorization.memo).to eq shopify_refund.note
        end
      end

      context 'sets return authorization associations' do
        let(:spree_return_authorization) { subject.create }
        let(:stock_location) { Spree::StockLocation.find_by!(name: I18n.t(:shopify)) }
        let(:reason) { Spree::ReturnAuthorizationReason.find_by!(name: I18n.t(:shopify)) }

        it 'order' do
          expect(spree_return_authorization.order).to eq spree_order
        end

        it 'stock location' do
          expect(spree_return_authorization.stock_location).to eq stock_location
        end

        it 'reason' do
          expect(spree_return_authorization.reason).to eq reason
        end
      end
    end
  end
end
