require 'spec_helper'

RSpec.describe ShopifyImport::Products::Create, type: :service do
  subject { described_class.new(product_data_feed) }

  before { ShopifyAPI::Base.site = 'https://foo:baz@test_shop.myshopify.com/admin' }

  describe '#call' do
    context 'with base product data feed', vcr: { cassette_name: 'shopify/base_product' } do
      let(:shopify_product) { ShopifyAPI::Product.find(9_884_552_707) }
      let(:product_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: '9884552707', data_feed: shopify_product.to_json)
      end

      it 'create spree product' do
        expect { subject.save! }.to change(Spree::Product, :count).by(1)
      end

      it 'assigns shopify data feed to product' do
        subject.save!
        expect(product_data_feed.reload.spree_object).to eq Spree::Product.find_by!(name: shopify_product.title)
      end

      context 'product attributes' do
        let(:spree_product) { Spree::Product.find_by!(name: shopify_product.title) }

        before { subject.save! }

        it 'description' do
          expect(spree_product.description).to eq shopify_product.body_html
        end

        it 'available_on' do
          expect(spree_product.available_on).to eq shopify_product.published_at
        end

        it 'slug' do
          expect(spree_product.slug).to eq shopify_product.handle
        end

        it 'created_at' do
          expect(spree_product.created_at).to eq shopify_product.created_at
        end

        it 'price'

        it 'shipping_category'
      end

      context 'product tags' do
        let(:spree_product) { Spree::Product.find_by!(name: shopify_product.title) }

        it 'creates product tags' do
          subject.save!
          expect(spree_product.tag_list).to match_array %w[tag some product]
        end
      end

      context 'option types' do
        let(:spree_product) { Spree::Product.find_by!(name: shopify_product.title) }
        let(:shopify_product) { create(:shopify_product_multiple_variants, variants_count: 2, options_count: 2) }
        let(:option_types_names) { shopify_product.options.map(&:name).map(&:downcase) }

        it 'creates option types' do
          expect { subject.save! }.to change(Spree::OptionType, :count).by(2)
        end

        it 'assigns option types to product' do
          subject.save!
          expect(spree_product.option_types.pluck(:name)).to match_array option_types_names
        end

        context 'option values' do
          let(:f_option_type) { Spree::OptionType.find_by(name: shopify_product.options.first.name.downcase) }
          let(:s_option_type) { Spree::OptionType.find_by(name: shopify_product.options.first.name.downcase) }
          let(:f_ot_values) { shopify_product.options.first.values }
          let(:s_ot_values) { shopify_product.options.last.values }

          it 'creates option values' do
            expect { subject.save! }.to change(Spree::OptionValue, :count).by(4)
          end

          it 'assigns option values to option types' do
            subject.save!
            expect(f_option_type.option_values.pluck(:name)).to match_array f_ot_values
            expect(s_option_type.option_values.pluck(:name)).to match_array s_ot_values
          end
        end
      end
    end
  end
end
