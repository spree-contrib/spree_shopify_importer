require 'spec_helper'

describe ShopifyImport::DataParsers::Refunds::BaseData, type: :service do
  let(:shopify_refund) { create(:shopify_refund) }
  let(:shopify_transaction) { create(:shopify_transaction, parent_id: 12_345) }
  let(:spree_reimbursement) { create(:reimbursement) }

  subject { described_class.new(shopify_refund, shopify_transaction, spree_reimbursement) }

  describe '#attributes' do
    let(:payment) { create(:payment) }
    let(:reason) { Spree::RefundReason.find_by!(name: I18n.t(:shopify)) }
    let!(:shopify_data_feed) do
      create(:shopify_data_feed,
             shopify_object_id: shopify_transaction.parent_id,
             shopify_object_type: 'ShopifyAPI::Transaction',
             spree_object: payment)
    end
    let(:result) do
      {
        payment: payment,
        amount: shopify_transaction.amount,
        transaction_id: shopify_transaction.authorization,
        reason: reason,
        reimbursement: spree_reimbursement
      }
    end

    it 'returns hash of refund attributes' do
      expect(subject.attributes).to eq result
    end
  end

  describe '#transaction_id' do
    it 'returns hash of refund attributes' do
      expect(subject.transaction_id).to eq shopify_transaction.authorization
    end
  end

  describe '#timestamps' do
    let(:result) do
      {
        created_at: shopify_refund.created_at.to_datetime,
        updated_at: shopify_refund.processed_at.to_datetime
      }
    end

    it 'returns hash of refund timestamps' do
      expect(subject.timestamps).to eq result
    end
  end
end
