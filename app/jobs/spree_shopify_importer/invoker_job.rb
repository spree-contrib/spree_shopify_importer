module SpreeShopifyImporter
  class InvokerJob < ::SpreeShopifyImporterJob
    def perform(credentials: nil)
      SpreeShopifyImporter::Invoker.new(credentials: credentials).import!
    end
  end
end
