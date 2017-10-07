require 'spec_helper'

describe ShopifyImport::DataSavers::Refunds::RefundCreator, type: :service do
  let(:spree_reimbursement) { create(:reimbursement) }

  subject { described_class.new(shopify_refund, shopify_transaction, spree_reimbursement) }

  before { authenticate_with_shopify }

  describe 'create' do
    context 'with base refund data', vcr: { cassette_name: 'shopify/base_refund' } do
      let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }
      let(:shopify_transaction) { shopify_refund.transactions.first }

      it 'creates spree refund' do
        expect { subject.create }.to change(Spree::Refund, :count).by(1)
      end

      context 'sets a refund attributes' do
        let(:spree_refund) { subject.create }

        it 'amount' do
          expect(spree_refund.amount).to eq 150
        end

        it 'transaction_id' do
          expect(spree_refund.transaction_id).to eq shopify_transaction.authorization
        end
      end

      context 'sets a refund associations' do
        let(:spree_refund) { subject.create }
        let(:payment) { create(:payment) }
        let(:reason) { Spree::RefundReason.find_by!(name: I18n.t(:shopify)) }
        let!(:shopify_data_feed) do
          create(:shopify_data_feed,
                 shopify_object_id: shopify_transaction.parent_id,
                 shopify_object_type: 'ShopifyAPI::Transaction',
                 spree_object: payment)
        end

        it 'payment' do
          expect(spree_refund.payment).to eq payment
        end

        it 'reason' do
          expect(spree_refund.reason).to eq reason
        end

        it 'reimbursement' do
          expect(spree_refund.reimbursement).to eq spree_reimbursement
        end
      end

      context 'sets a refund timestamps' do
        let(:spree_refund) { subject.create }

        it 'created_at' do
          expect(spree_refund.created_at).to eq shopify_refund.created_at
        end

        it 'updated_at' do
          expect(spree_refund.updated_at).to eq shopify_refund.processed_at
        end
      end
    end
  end
end
