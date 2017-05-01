require 'spec_helper'

RSpec.describe ShopifyImport::Importers::BaseImporter, type: :service do
  describe '.import!' do
    let(:expected_message) { I18n.t('errors.not_implemented.resources') }

    it 'raises not implemented error for resources' do
      expect { described_class.import! }.to raise_error(NotImplementedError).with_message(expected_message)
    end

    it 'raises not implemented error for creator'
  end
end
