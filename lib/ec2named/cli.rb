# encoding: utf-8
# frozen_string_literal: true

module Ec2named
  class CLI
    def initialize
      STDERR.puts "ARGV contains unprocessed arguments #{ARGV}" unless !query.nil? && ARGV.empty?
    end

    def run
      STDERR.puts query_str if opts[:"show-query"]

      unless query.errors.empty?
        query.errors.each { |msg| STDERR.puts(msg) }
        return
      end

      instances = query.instances
      return unless instances.any?

      query.save_result_to_file if opts[:debug]

      display instances
    end

    private

    def query_str
      (opts[:list] ? ">" : "> limit:1") + " #{query.filters_str}"
    end

    def query
      @query ||= Ec2named::Query.new(query_args)
    end

    def environments
      Ec2named.config["environments"]
    end

    def display(instances)
      print_it = lambda { |instance| instance.print(opts[:verbose]) }

      if opts[:list]
        instances.each(&print_it)
      else
        instances.first.tap(&print_it)
      end
    end

    # rubocop:disable Metrics/MethodLength
    def opts
      @opts ||= Trollop.options do
        opt :list, "display all matching instances, including those not in-use", short: 'l'
        opt :verbose, "display more instance attributes to stderr in addition to ip", short: 'v'
        opt :"show-query", "print the describe-instance query filter", short: 'q'
        opt :debug, "write debug_response.txt for later inspection"
        opt :"no-default", "don't apply default filters", short: 'x'

        opt :tags, "filter on arbitrary tags (e.g. class:pipeline,name:_bastion_)", short: 't', type: String
        opt :name, "filter on tag:Name, using _ for wildcard (e.g. jenkins_, _standby, _labs_)", short: 'n', type: String
        opt :type, "filter on instance-type (e.g. t2.micro, c4.xlarge, m3.medium)", short: 'y', type: String
        opt :id, "filter on ec2 instance-id", short: 'i', type: String
        opt :key_name, "filter on amazon ssh key name (e.g. development, production)", short: 'k', type: String
      end
      @opts[:verbose] = true if @opts[:all]
      @opts
    end

    def query_args
      @query_args = opts.merge(parse_argv)
      @query_args = @query_args.each do |key, val|
        @query_args[key] = underscores_are_wild(key, val) if val.is_a?(String)
      end
    end

    def underscores_are_wild(key, value)
      if key == :tags
        value.split(',').map { |tag_spec| wildcard_keys(tag_spec) }.join(',')
      else
        value.gsub(/_+/, '*')
      end
    end

    def wildcard_keys(tag_spec)
      k,v = tag_spec.split(':')
      [k, v.gsub(/_+/, '*')].join(':')
    end

    def parse_argv
      args = {}
      args[:env] = ARGV.find { |arg| environments.any? { |env_name| env_name == arg } }
      ARGV.delete(args[:env])

      args[:app] = ARGV.first
      ARGV.delete(args[:app])
      args
    end
  end
end
