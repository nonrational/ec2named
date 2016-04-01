# encoding: utf-8
# frozen_string_literal: true

module Ec2named
  class Query
    def initialize(opts) # rubocop:disable Metrics/AbcSize
      @opts = opts
      @ec2_client = Aws::EC2::Client.new

      [:Name, :env, :app, :class].each { |tag_name| add_tag_filter_if_given(tag_name) }

      add_filter_if_given(:type)
      add_filter_if_given(:key_name)
      add_filter_if_given(:id)

      add_raw_tag_filters_if_given
      add_filter(Filter.tag_status_in_use) unless opts[:env].nil? || opts[:statuses]
      add_filter(Filter.tag_status_zombie) if opts[:zombie]

      add_filter(Filter.all) if filters.empty?
    end # rubocop:enable

    def result
      @result ||= ec2_client.describe_instances(filters: filters).reservations.map(&:instances).flatten
    end

    def save_result_to_file(filename = "debug_response.txt")
      File.open(filename, "w") do |f|
        PP.pp(result.map { |o| Hash[o.each_pair.to_a] }, f)
      end
    end

    def instances
      @instances ||= result.map { |inst| Ec2named::Instance.new(inst) }
    end

    def add_filter(filter)
      filters << filter
    end

    def filters_str
      filters.map { |f| "#{f[:name]}:#{f[:values].join('|')}" }.join(" ").to_s
    end

    private

    attr_reader :ec2_client, :opts

    def add_tag_filter_if_given(tag_name, option_name = tag_name.downcase)
      add_filter(Filter.tag(tag_name, opts[option_name])) if opts[option_name]
    end

    def add_filter_if_given(filter_property)
      add_filter(Filter.public_send(filter_property, opts[filter_property])) if opts[filter_property]
    end

    def add_raw_tag_filters_if_given
      if opts[:tags_given]
        opts[:tags].split(',').each do |tag_spec|
          tag_pair = tag_spec.split(':')
          add_filter(Filter.tag(tag_pair[0], tag_pair[1]))
        end
      end
    end

    def filters
      @filters ||= []
    end
  end
end
