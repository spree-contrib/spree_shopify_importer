module ShopifyImport
  class Delegator
    include RescueApiLimit

    def initialize(target)
      @target = target
    end

    # Handles 429 API exception
    def method_missing(method_name, *args, &block)
      if respond_to_missing?(method_name)
        handle_known_exceptions do
          @target.send(method_name, *args, &block)
        end
      else
        super
      end
    end

    private

    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.in?(%w[save save! create create! update update!]) || super
    end
  end
end
