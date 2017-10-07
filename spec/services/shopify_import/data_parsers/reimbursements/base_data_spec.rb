require 'spec_helper'

describe ShopifyImport::DataParsers::Reimbursements::BaseData, type: :service do
  let(:shopify_refund) { create(:shopify_refund) }
  let(:spree_customer_return) { create(:customer_return) }
  let(:spree_order) { create(:order) }

  subject { described_class.new(shopify_refund, spree_customer_return, spree_order) }

  describe '#number' do
    it 'returns reimbursement number' do
      expect(subject.number).to eq "SRI#{shopify_refund.id}"
    end
  end

  describe '#attributes' do
    let(:result) do
      {
        reimbursement_status: :reimbursed,
        customer_return: spree_customer_return,
        order: spree_order,
        total: 0
      }
    end

    it 'returns hash of reimbursement attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#timestamps' do
    let(:result) do
      {
        created_at: shopify_refund.created_at.to_datetime,
        updated_at: shopify_refund.processed_at.to_datetime
      }
    end

    it 'returns hash of reimbursement timestamps' do
      expect(subject.timestamps).to eq result
    end
  end
end
