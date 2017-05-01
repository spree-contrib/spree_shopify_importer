module ShopifyImport
  class Base
    def initialize(credentials: {}, client: nil)
      @client = client || client(credentials)
    end

    def count(**opts)
      api_class.get(:count, opts)
    end

    def find_all(**opts)
      results = []
      find_in_batches(**opts) do |batch|
        break if batch.blank?
        results += batch
      end
      results
    end

    private

    def find_in_batches(**opts)
      opts = { page: 1 }.merge(opts)
      loop do
        batch = api_class.find(:all, params: opts)
        yield batch
        break if batch.blank?
        opts[:page] += 1
      end
    end

    def client(credentials)
      ShopifyImport::Client.instance.get_connection(credentials)
    end

    def api_class
      "ShopifyAPI::#{self.class.to_s.demodulize}".constantize
    end
  end
end
