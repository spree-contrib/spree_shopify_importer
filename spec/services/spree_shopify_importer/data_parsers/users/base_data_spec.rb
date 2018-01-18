require 'spec_helper'

RSpec.describe SpreeShopifyImporter::DataParsers::Users::BaseData do
  subject { described_class.new(shopify_customer) }
  let(:shopify_customer) { create(:shopify_customer) }

  describe '#attributes' do
    context 'with sample customer' do
      let(:user_attributes) do
        {
          created_at: shopify_customer.created_at,
          email: shopify_customer.email,
          login: shopify_customer.email,
          first_name: shopify_customer.first_name,
          last_name: shopify_customer.last_name
        }
      end

      it 'prepares hash of attributes' do
        expect(subject.attributes).to eq(user_attributes)
      end
    end
  end

  describe '#temp_password' do
    before do
      allow(SecureRandom).to receive(:hex) { 'password' }
    end

    it 'returns SecureRandom password' do
      expect(subject.temp_password).to eq 'password'
    end
  end
end
