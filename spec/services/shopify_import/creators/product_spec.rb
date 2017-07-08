require 'spec_helper'

RSpec.describe ShopifyImport::Creators::Product, type: :service do
  subject { described_class.new(product_data_feed) }

  before { authenticate_with_shopify }

  describe '#save!' do
    context 'with base product data feed', vcr: { cassette_name: 'shopify/base_product' } do
      let(:shopify_product) { ShopifyAPI::Product.find(11_101_525_828) }
      let(:product_data_feed) do
        create(:shopify_data_feed,
               shopify_object_id: shopify_product.id, data_feed: shopify_product.to_json)
      end

      it 'create spree product' do
        expect { subject.save! }.to change(Spree::Product, :count).by(1)
      end

      it 'assigns shopify data feed to product' do
        subject.save!
        expect(product_data_feed.reload.spree_object).to eq Spree::Product.find_by!(name: shopify_product.title)
      end

      context 'product attributes' do
        let(:spree_product) { Spree::Product.find_by!(slug: shopify_product.handle) }

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
        let(:spree_product) { Spree::Product.find_by!(slug: shopify_product.handle) }

        it 'creates product tags' do
          subject.save!
          expect(spree_product.tag_list).to match_array %w[tag some product]
        end
      end

      context 'spree variants' do
        let(:spree_product) { Spree::Product.find_by!(slug: shopify_product.handle) }

        it 'creates spree variant' do
          expect { subject.save! }.to change(Spree::Variant, :count).by(2)
        end

        it 'assings variants to product' do
          subject.save!
          expect(Spree::Variant.last.product).to eq spree_product
        end
      end

      context 'shopify data feeds for variants' do
        it 'creates data feeds' do
          expect { subject.save! }.to change {
            Shopify::DataFeed.where(shopify_object_type: 'ShopifyAPI::Variant').reload.count
          }.by(1)
        end
      end

      context 'option types' do
        let(:spree_product) { Spree::Product.find_by!(slug: shopify_product.handle) }
        let(:shopify_product) do
          create(:shopify_product_multiple_variants, variants_count: 2, options_count: 2, handle: 'some-handle')
        end
        let(:option_types_names) { shopify_product.options.map(&:name).map(&:downcase) }

        it 'creates variants' do
          expect { subject.save! }.to change(Spree::Variant, :count).by(3)
        end

        it 'creates option types' do
          expect { subject.save! }.to change(Spree::OptionType, :count).by(2)
        end

        it 'assigns option types to product' do
          subject.save!
          expect(spree_product.option_types.pluck(:name)).to match_array option_types_names
        end

        context 'option values' do
          let(:option_type1) { Spree::OptionType.find_by(name: shopify_product.options.first.name.downcase) }
          let(:option_type2) { Spree::OptionType.find_by(name: shopify_product.options.first.name.downcase) }
          let(:option_type1_values) { shopify_product.options.first.values.map(&:downcase) }
          let(:option_type2_values) { shopify_product.options.last.values.map(&:downcase) }

          it 'creates option values' do
            expect { subject.save! }.to change(Spree::OptionValue, :count).by(6)
          end

          it 'assigns option values to option types' do
            subject.save!
            expect(option_type1.option_values.pluck(:name)).to match_array option_type1_values
            expect(option_type2.option_values.pluck(:name)).to match_array option_type2_values
          end
        end
      end
    end
  end
end
