module ShopifyImport
  class InvokerJob < ApplicationJob
    def perform(credentials: nil)
      ShopifyImport::Invoker.new(credentials: credentials).import!
    end
  end
end
