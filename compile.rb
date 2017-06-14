require 'rspec-puppet'
require 'json'
require 'cri'

class SOE
  class Compiler
    include RSpec::Puppet::Support

    attr_accessor :code, :node_name, :facts, :hiera_config, :environment
    attr_reader :modulepath

    def modulepath=(value)
      Puppet[:modulepath] = value
    end

    def adapter
      @adapter ||= begin
        adapter = RSpec::Puppet::Adapters.get
        adapter.setup_puppet(self)
        Puppet::Test::TestHelper.initialize
        Puppet::Test::TestHelper.before_each_test
        adapter
      end
    end

    def build
      build_catalog_without_cache(node_name, facts, hiera_config, code, nil).resources.reject { |r|
        ['Class', 'Stage'].include?(r.type)
      }.map { |r|
        temp = r.to_hash.merge(:type => r.type.downcase)

        if r.builtin_type?
          temp[:name] = r.uniqueness_key.first
          temp.delete(r.key_attributes.first)
        end

        temp
      }
    end
  end

  class CLI
    @cmd ||= Cri::Command.define do
      name 'soe-compile'
      usage 'soe-compile <puppet class> [options]'
      summary 'see description'
      description 'see summary'

      option :n, :node, 'The name of the node', {:argument => :required}
      option :f, :facts, 'The path to the facts json', {:argument => :required}
      option :r, :hiera, 'The path to the hiera config file', {:argument => :required}
      option :e, :environment, 'The environment name', {:argument => :required}
      option :m, :modulepath, 'The path to the modules', {:argument => :required, :multiple => true}

      flag :h, :help, 'Show this help message' do |_, c|
        puts c.help
        exit 0
      end

      run do |opts, args, cmd|
        klass = args.first
        pattern = "**/#{File.join(klass.split('::').insert(1, 'manifests'))}.pp"

        s = SOE::Compiler.new
        manifest_file = opts[:modulepath].map { |r| Dir.glob("#{r}/#{pattern}") }.flatten.first
        s.code = File.read(manifest_file) + "\ninclude #{klass}"

        s.node_name = opts.fetch(:node, 'testhost.example.com')
        s.facts = opts.key?(:facts) ? JSON.parse(File.read(opts[:facts])) : {}
        s.environment = opts.fetch(:environment, 'production')
        s.hiera_config = opts.fetch(:hiera_config, nil)
        s.modulepath = opts[:modulepath].join(':')
        puts JSON.generate(s.build)
      end
    end

    def self.run(args)
      @cmd.run(args)
    end
  end
end

SOE::CLI.run(ARGV)
