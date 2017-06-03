guard :bundler do
  require 'guard/bundler'
  require 'guard/bundler/verify'
  helper = Guard::Bundler::Verify.new

  files = ['Gemfile']
  files += Dir['*.gemspec'] if files.any? { |f| helper.uses_gemspec?(f) }

  # Assume files are symlinked from somewhere
  files.each { |file| watch(helper.real_path(file)) }
end

guard :rubocop, all_on_start: false, cli: '-aDERS' do
  watch(/.+\.rb$/)
  watch(/.+\.rake$/)
  watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
end

guard :rspec, cmd: 'spring rspec', failed_mode: :keep do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # watch /app files
  watch(%r{^app/(.+)/shopify_import/(.+).rb$}) do |m|
    "spec/#{m[1]}/shopify_import/#{m[2]}_spec.rb"
  end
  watch(%r{^app/(.+)/spree/(.+).rb$}) do |m|
    "spec/#{m[1]}/spree/#{m[2]}_spec.rb"
  end
  watch(%r{^app/(.+)/spree/(.+)_decorator.rb$}) do |m|
    "spec/#{m[1]}/spree/#{m[2]}_spec.rb"
  end
end

guard 'spring', bundler: true do
  watch('Gemfile.lock')
  watch(%r{^config/})
  watch(%r{^lib/})
  watch(%r{^spec/(support|factories)/})
  watch(%r{^spec/factory.rb})
end
