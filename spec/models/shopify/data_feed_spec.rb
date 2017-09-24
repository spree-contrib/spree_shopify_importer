require 'spec_helper'

RSpec.describe Shopify::DataFeed, type: :model do
  describe 'database' do
    it { is_expected.to have_db_index([:shopify_object_id, :shopify_object_type]).unique }
    it { is_expected.to have_db_index([:spree_object_id, :spree_object_type]).unique }
    it { is_expected.to have_db_index(:parent_id) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:shopify_object_id) }
    it { is_expected.to validate_presence_of(:shopify_object_type) }

    context 'uniqueness validations' do
      subject { build(:shopify_data_feed) }

      it { is_expected.to validate_uniqueness_of(:shopify_object_id).scoped_to(:shopify_object_type) }
      it { is_expected.to validate_uniqueness_of(:spree_object_id).scoped_to(:spree_object_type).allow_nil }
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:spree_object) }
    it { is_expected.to belong_to(:parent).class_name('Shopify::DataFeed') }
    it 'to have many children data feeds' do
      is_expected
        .to have_many(:children).class_name('Shopify::DataFeed').with_foreign_key(:parent_id).dependent(:destroy)
    end
  end
end
