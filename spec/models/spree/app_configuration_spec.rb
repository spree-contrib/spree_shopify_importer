require 'spec_helper'

describe Spree::AppConfiguration, type: :model do
  describe 'defaults' do
    it 'shopify_rescue_limit' do
      expect(Spree::Config[:shopify_rescue_limit]).to eq 5
    end

    it 'shopify_import_queue' do
      expect(Spree::Config[:shopify_import_queue]).to eq 'default'
    end
  end
end
