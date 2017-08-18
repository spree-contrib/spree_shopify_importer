require 'spec_helper'

RSpec.feature 'end to end import' do
  include ActiveJob::TestHelper

  it 'imports successfully', vcr: { cassette_name: 'integration' } do
    perform_enqueued_jobs do
      ShopifyImport::Invoker.new(
        credentials: {
          api_key: '0a9445b7b067719a0af024610364ee34', password: '800f97d6ea1a768048851cdd99a9101a',
          shop_domain: 'spree-shopify-importer-test-store.myshopify.com'
        }
      ).import!
    end

    expect(Spree::Product.count).to eq 2
    expect(Spree::Variant.count).to eq 4
    expect(Spree.user_class.count).to eq 2
    expect(Spree::Taxonomy.count).to eq 1
    expect(Spree::Taxon.count).to eq 2
  end
end
