require 'spec_helper'

describe ShopifyImport::DataSavers::ReturnItems::ReturnItemCreator, type: :service do
  subject { described_class.new(shopify_refund_line_item, shopify_refund, return_authorization, inventory_unit) }

  before { authenticate_with_shopify }

  describe '#create' do
    let(:return_authorization) { create(:return_authorization) }
    let(:inventory_unit) { create(:inventory_unit) }

    context 'with base refund data', vcr: { cassette_name: 'shopify/base_refund' } do
      let(:shopify_refund) { ShopifyAPI::Refund.find(225_207_300, params: { order_id: 5_182_437_124 }) }
      let(:shopify_refund_line_item) { shopify_refund.refund_line_items.first }

      it 'creates a return item' do
        expect { subject.create }.to change(Spree::ReturnItem, :count).by(1)
      end

      it 'changes inventory unit state' do
        subject.create

        expect(inventory_unit.reload.state).to eq 'returned'
      end

      context 'sets a return item attributes' do
        let(:spree_return_item) { subject.create }

        it 'pre_tax_amount' do
          expect(spree_return_item.pre_tax_amount).to eq 150
        end

        it 'additional_tax_total' do
          expect(spree_return_item.additional_tax_total).to eq 0
        end

        it 'resellable' do
          expect(spree_return_item.resellable).to eq false
        end

        it 'acceptance_status' do
          expect(spree_return_item.acceptance_status).to eq 'accepted'
        end

        it 'reception_status' do
          expect(spree_return_item.reception_status).to eq 'received'
        end
      end

      context 'sets a return item associations' do
        let(:spree_return_item) { subject.create }
        let(:reimbursement_type) { Spree::ReimbursementType.find_by!(name: I18n.t(:shopify)) }

        it 'preferred_reimbursement_type' do
          expect(spree_return_item.preferred_reimbursement_type).to eq reimbursement_type
        end

        it 'return_authorization' do
          expect(spree_return_item.return_authorization).to eq return_authorization
        end

        it 'inventory_unit' do
          expect(spree_return_item.inventory_unit).to eq inventory_unit
        end
      end

      context 'sets a return item timestamps' do
        let(:spree_return_item) { subject.create }

        it 'created at' do
          expect(spree_return_item.created_at).to eq shopify_refund.created_at
        end

        it 'updated at' do
          expect(spree_return_item.updated_at).to eq shopify_refund.processed_at
        end
      end
    end
  end
end
