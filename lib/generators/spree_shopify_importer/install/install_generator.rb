module SpreeShopifyImporter
  module Generators
    class InstallGenerator < Rails::Generators::Base
      class_option :auto_run_migrations, type: :boolean, default: false

      def add_javascripts
        # Not required
      end

      def add_stylesheets
        # Not required
      end

      def add_migrations
        run 'rails railties:install:migrations FROM=spree_shopify_importer'
      end

      def run_migrations
        run_migrations =
          options[:auto_run_migrations] ||
          ['', 'y', 'Y'].include?(ask('Would you like to run the migrations now? [Y/n]'))

        if run_migrations
          run 'rails db:migrate'
        else
          puts "Skipping rails db:migrate, don't forget to run it!"
        end
      end
    end
  end
end
