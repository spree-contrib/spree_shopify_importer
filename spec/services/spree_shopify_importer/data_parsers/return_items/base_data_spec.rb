require 'spec_helper'

describe SpreeShopifyImporter::DataParsers::ReturnItems::BaseData, type: :service do
  let(:shopify_refund) { create(:shopify_refund) }
  let(:inventory_unit) { create(:inventory_unit) }
  let(:return_authorization) { create(:return_authorization) }

  subject { described_class.new(shopify_refund_line_item, shopify_refund, return_authorization, inventory_unit) }

  before { authenticate_with_shopify }

  describe '#attributes', vcr: { cassette_name: 'shopify/base_refund' } do
    let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }
    let(:shopify_refund_line_item) { shopify_refund.refund_line_items.first }
    let(:reimbursement_type) { Spree::ReimbursementType.find_by!(name: I18n.t(:shopify)) }

    let(:result) do
      {
        pre_tax_amount: 150,
        additional_tax_total: 0,
        resellable: false,
        acceptance_status: :accepted,
        reception_status: :received,
        preferred_reimbursement_type: reimbursement_type,
        return_authorization: return_authorization,
        inventory_unit: inventory_unit
      }
    end

    it 'returns hash of return item attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#timestamps' do
    let(:shopify_refund_line_item) { double('ShopifyAPI::Refund::RefundLineItem') }

    let(:result) do
      {
        created_at: shopify_refund.created_at.to_datetime,
        updated_at: shopify_refund.processed_at.to_datetime
      }
    end

    it 'returns hash of return item timestamps' do
      expect(subject.timestamps).to eq result
    end
  end
end
