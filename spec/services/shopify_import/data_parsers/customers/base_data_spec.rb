require 'spec_helper'

RSpec.describe ShopifyImport::DataParsers::Customers::BaseData do
  subject { described_class.new(shopify_customer) }
  let(:shopify_customer) { create(:shopify_customer) }

  describe '#user_attributes' do
    context 'with sample customer' do
      let(:user_attributes) do
        {
          created_at: shopify_customer.created_at,
          email: shopify_customer.email,
          first_name: shopify_customer.first_name,
          last_name: shopify_customer.last_name
        }
      end

      it 'prepares hash of attributes' do
        expect(subject.user_attributes).to eq(user_attributes)
      end
    end
  end
end
