require 'spec_helper'

describe ShopifyImport::DataSavers::Refunds::RefundsCreator, type: :service do
  let(:spree_reimbursement) { create(:reimbursement) }

  subject { described_class.new(shopify_refund, spree_reimbursement) }

  before { authenticate_with_shopify }

  describe '#create' do
    context 'with base refund data', vcr: { cassette_name: 'shopify/base_refund' } do
      let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }

      before do
        shopify_refund.transactions.each do |transaction|
          payment = create(:payment)
          create(:shopify_data_feed,
                 shopify_object_id: transaction.parent_id,
                 shopify_object_type: 'ShopifyAPI::Transaction',
                 spree_object: payment)
        end
      end

      it 'creates spree refunds' do
        expect { subject.create }.to change(Spree::Refund, :count).by(1)
      end
    end
  end
end
