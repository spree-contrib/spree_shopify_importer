module ShopifyImport
  module Importers
    class UserImporterJob < ApplicationJob
      def perform(resource)
        ShopifyImport::Importers::UserImporter.new(resource).import!
      end
    end
  end
end
