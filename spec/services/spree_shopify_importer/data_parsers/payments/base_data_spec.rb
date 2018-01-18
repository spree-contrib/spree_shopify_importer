require 'spec_helper'

describe SpreeShopifyImporter::DataParsers::Payments::BaseData, type: :service do
  let(:shopify_transaction) { create(:shopify_transaction) }
  subject { described_class.new(shopify_transaction) }

  describe '#payment_number' do
    it 'creates number with transaction id' do
      expect(subject.number).to eq "SP#{shopify_transaction.id}"
    end
  end

  describe '#payment_attributes' do
    let(:payment_method) { Spree::PaymentMethod.find_by(name: shopify_transaction.gateway) }
    let(:result) do
      {
        amount: shopify_transaction.amount,
        state: :completed,
        payment_method: payment_method
      }
    end

    it 'creates shopify payment method' do
      expect { subject.attributes }.to change(Spree::PaymentMethod, :count).by(1)
    end

    it 'creates a hash of variant attributes' do
      expect(subject.attributes).to eq result
    end

    context 'payment states' do
      [
        { kind: 'authorization', status: 'pending', spree_state: :pending },
        { kind: 'authorization', status: 'failure', spree_state: :failed },
        { kind: 'capture', status: 'success', spree_state: :completed },
        { kind: 'sale', status: 'error', spree_state: :failed },
        { kind: 'void', status: 'success', spree_state: :void }
      ].each do |payment_hash|
        it "for a kind #{payment_hash[:kind]} and status #{payment_hash[:status]} it returns a proper state" do
          transaction = create(:shopify_transaction, kind: payment_hash[:kind], status: payment_hash[:status])
          parser = described_class.new(transaction)

          expect(parser.attributes[:state]).to eq payment_hash[:spree_state]
        end
      end
    end

    context 'for wrong payment status' do
      let(:shopify_transaction) { create(:shopify_transaction, kind: 'authorization', status: 'random') }
      let(:error) { SpreeShopifyImporter::DataParsers::Payments::BaseData::InvalidStatus }
      let(:error_message) { I18n.t('errors.transaction.no_payment_state', status: 'random') }

      it 'raises a error message' do
        expect { subject.attributes }.to raise_error(error).with_message(error_message)
      end
    end
  end

  describe '#payment_timestamps' do
    let(:result) do
      {
        created_at: shopify_transaction.created_at.to_datetime,
        updated_at: shopify_transaction.created_at.to_datetime
      }
    end

    it 'creates hash of payment timestamps' do
      expect(subject.timestamps).to eq result
    end
  end
end
