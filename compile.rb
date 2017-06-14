require 'rspec-puppet'
require 'json'

class SOE
  include RSpec::Puppet::Support

  attr_accessor :code, :node_name, :facts, :hiera_config

  def adapter
    @adapter ||= begin
      adapter = RSpec::Puppet::Adapters.get
      adapter.setup_puppet(self)
      Puppet::Test::TestHelper.initialize
      Puppet::Test::TestHelper.before_each_test
      adapter
    end
  end

  def environment
    'test'
  end

  def build
    build_catalog_without_cache(node_name, facts, hiera_config, code, nil)
  end
end

s = SOE.new
s.code = File.read('site/profile/manifests/base.pp') + "\ninclude profile::base"
s.node_name = 'test'
s.facts = {}
puts JSON.generate(s.build.resources.reject { |r| ['Class', 'Stage'].include?(r.type) }.map { |r| r.to_hash })
