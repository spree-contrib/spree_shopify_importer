module ShopifyImport
  class InvokerJob < ::ShopifyImportJob
    def perform(credentials: nil)
      ShopifyImport::Invoker.new(credentials: credentials).import!
    end
  end
end
