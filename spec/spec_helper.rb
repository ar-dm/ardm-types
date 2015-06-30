require 'rspec'

require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'

require 'dm-types'
require 'dm-migrations'
require 'dm-validations'

Dir["#{Pathname(__FILE__).dirname.expand_path}/shared/*.rb"].each { |file| require file }

DataMapper::Spec.setup

RSpec.configure do |config|
  config.extend(DataMapper::Spec::Adapters::Helpers)
end
