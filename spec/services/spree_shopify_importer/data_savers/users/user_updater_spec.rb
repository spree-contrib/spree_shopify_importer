require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::Users::UserUpdater, type: :service do
  include ActiveJob::TestHelper

  subject { described_class.new(customer_data_feed, spree_user) }

  before { ShopifyAPI::Base.site = 'https://foo:baz@test_shop.myshopify.com/admin' }

  describe '#create!' do
    context 'with base customer data feed' do
      let!(:spree_user) { create(:user) }
      let(:shopify_customer) do
        ShopifyAPI::Customer.new(
          created_at: 2.days.ago, email: 'user@example.com',
          first_name: 'User', last_name: 'Example'
        )
      end
      let(:customer_data_feed) { create(:shopify_data_feed, data_feed: shopify_customer.to_json) }

      it 'create spree user' do
        expect { subject.update! }.not_to change(Spree.user_class, :count)
      end

      it 'generates spree api key' do
        subject.update!

        expect(spree_user.spree_api_key).not_to be_blank
      end

      context 'customer attributes' do
        it 'email' do
          subject.update!

          expect(spree_user.email).to eq(shopify_customer.email)
        end

        it 'assigns login from email' do
          subject.update!

          expect(spree_user.login).to eq(shopify_customer.email)
        end

        it 'created_at' do
          subject.update!

          expect(spree_user.created_at).to be_within(1.second).of(shopify_customer.created_at)
        end
      end

      context 'customer associations' do
        let(:shopify_address) { create(:shopify_address) }

        before do
          allow_any_instance_of(ShopifyAPI::Customer).to receive(:addresses).and_return([shopify_address])
        end

        it 'creates spree address' do
          expect do
            perform_enqueued_jobs do
              subject.update!
            end
          end.to change(Spree::Address, :count).by(1)
        end
      end
    end
  end
end
