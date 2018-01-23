require 'spec_helper'

describe SpreeShopifyImporter::DataSavers::Users::UserCreator, type: :service do
  include ActiveJob::TestHelper

  subject { described_class.new(customer_data_feed) }

  before { ShopifyAPI::Base.site = 'https://foo:baz@test_shop.myshopify.com/admin' }

  describe '#create!' do
    context 'with base customer data feed' do
      let(:shopify_customer) do
        ShopifyAPI::Customer.new(
          created_at: 2.days.ago, email: 'user@example.com',
          first_name: 'User', last_name: 'Example'
        )
      end
      let(:customer_data_feed) { create(:shopify_data_feed, data_feed: shopify_customer.to_json) }

      it 'create spree user' do
        expect { subject.create! }.to change(Spree.user_class, :count).by(1)
      end

      it 'skips sending confirmation email' do
        user = Spree.user_class.new
        allow(Spree.user_class).to receive(:new) do |method_attributes|
          user.assign_attributes(method_attributes)
          user
        end
        allow(user).to receive(:skip_confirmation!)

        subject.create!

        expect(user).to have_received(:skip_confirmation!)
      end

      it 'generates spree api key' do
        subject.create!
        spree_user = Spree.user_class.find_by!(email: shopify_customer.email)

        expect(spree_user.spree_api_key).not_to be_blank
      end

      it 'assigns shopify data feed to spree user' do
        subject.create!
        expect(customer_data_feed.reload.spree_object).to eq(Spree.user_class.find_by!(email: shopify_customer.email))
      end

      context 'customer attributes' do
        let(:spree_user) { Spree.user_class.find_by!(email: shopify_customer.email) }

        it 'assigns temp password to the user' do
          password = 'hex_password'
          allow(SecureRandom).to receive(:hex).and_call_original
          allow(SecureRandom).to receive(:hex).with(64).and_return(password)

          subject.create!

          expect(spree_user.valid_password?(password)).to be true
        end

        it 'email' do
          subject.create!

          expect(spree_user.email).to eq(shopify_customer.email)
        end

        it 'assigns login from email' do
          subject.create!

          expect(spree_user.login).to eq(shopify_customer.email)
        end

        it 'created_at' do
          subject.create!

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
              subject.create!
            end
          end.to change(Spree::Address, :count).by(1)
        end
      end
    end
  end
end
