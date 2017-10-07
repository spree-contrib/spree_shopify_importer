require 'spec_helper'

describe ShopifyImport::DataParsers::ReturnAuthorizations::BaseData, type: :service do
  let(:shopify_refund) { create(:shopify_refund) }
  let(:spree_order) { create(:order) }
  subject { described_class.new(shopify_refund, spree_order) }

  describe '#number' do
    it 'returns return authorization number with prefix' do
      expect(subject.number).to eq "SRE#{shopify_refund.id}"
    end
  end

  describe '#attributes' do
    let(:stock_location) do
      Spree::StockLocation.find_by!(name: I18n.t(:shopify))
    end
    let(:reason) do
      Spree::ReturnAuthorizationReason.find_by!(name: I18n.t(:shopify))
    end
    let(:result) do
      {
        state: :authorized,
        order: spree_order,
        memo: shopify_refund.note,
        stock_location: stock_location,
        reason: reason
      }
    end

    it 'creates shopify stock location' do
      expect { subject.attributes }.to change(Spree::StockLocation, :count).by(1)
    end

    it 'creates shopify reason' do
      expect { subject.attributes }.to change(Spree::ReturnAuthorizationReason, :count).by(1)
    end

    it 'returns hash of return authorization attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#timestamps' do
    let(:result) do
      {
        created_at: shopify_refund.created_at,
        updated_at: shopify_refund.processed_at
      }
    end

    it 'returns hash of return authorization timestamps' do
      expect(subject.timestamps).to eq result
    end
  end
end
