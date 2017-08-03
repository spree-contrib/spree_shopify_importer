require 'spec_helper'

describe Spree::Calculator::ShopifyTax, type: :model do
  subject { described_class }

  describe '.description' do
    it 'returns calculator descrption' do
      expect(subject.description).to eq I18n.t('shopify')
    end
  end
end
