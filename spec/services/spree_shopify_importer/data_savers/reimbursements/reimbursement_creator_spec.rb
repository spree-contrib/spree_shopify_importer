require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::Reimbursements::ReimbursementCreator, type: :service do
  let(:spree_customer_return) { create(:customer_return) }
  let(:spree_order) { create(:order) }

  subject { described_class.new(shopify_refund, spree_customer_return, spree_order) }

  before { authenticate_with_shopify }

  describe '#create' do
    context 'with base shopify refund data', vcr: { cassette_name: 'shopify/base_refund' } do
      let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }

      it 'creates spree reimbursement' do
        expect { subject.create }.to change(Spree::Reimbursement, :count).by(1)
      end

      context 'sets the reimbursement attributes' do
        let(:spree_reimbursement) { subject.create }

        it 'number' do
          expect(spree_reimbursement.number).to eq "SRI#{shopify_refund.id}"
        end

        it 'reimbursement_status' do
          expect(spree_reimbursement.reimbursement_status).to eq 'reimbursed'
        end

        it 'total' do
          expect(spree_reimbursement.total).to eq 150
        end
      end

      context 'sets the reimbursement associations' do
        let(:spree_reimbursement) { subject.create }

        it 'customer return' do
          expect(spree_reimbursement.customer_return).to eq spree_customer_return
        end

        it 'order' do
          expect(spree_reimbursement.order).to eq spree_order
        end

        it 'return items' do
          expect(spree_reimbursement.return_items).to eq spree_customer_return.reload.return_items
        end
      end

      context 'sets the reimbursement timestamps' do
        let(:spree_reimbursement) { subject.create }

        it 'created_at' do
          expect(spree_reimbursement.created_at).to eq shopify_refund.created_at
        end

        it 'updated_at' do
          expect(spree_reimbursement.updated_at).to eq shopify_refund.processed_at
        end
      end
    end
  end
end
