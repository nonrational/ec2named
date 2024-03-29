# encoding: utf-8
# frozen_string_literal: true

module Ec2named
  class Query
    # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    def initialize(opts)
      @opts = opts
      validate_aws_env

      add_tag_filter_if_given(application_tag, :app)
      add_tag_filter_if_given(environment_tag, :env)
      add_tag_filter_if_given(:Name, :name)

      add_filter_if_given(:type)
      add_filter_if_given(:key_name)
      add_filter_if_given(:id)

      add_raw_tag_filters_if_given
      add_default_tag_filters unless opts[:env].nil? || opts[:"no-default"]

      add_filter(Filter.all) if filters.empty?
    end
    # rubocop:enable

    def result
      @result ||= ec2_client.describe_instances(filters: filters).reservations.map(&:instances).flatten
    end

    def save_result_to_file(filename = "debug_response.yaml")
      File.write(filename, YAML.dump(result))
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

    def errors
      @errors ||= []
    end

    private

    attr_reader :opts

    def application_tag
      Ec2named.config["application_tag"] || "app"
    end

    def environment_tag
      Ec2named.config["environment_tag"] || "env"
    end

    def add_default_tag_filters
      default_tag_filters.each { |dtf| add_filter(dtf) }
    end

    def default_tag_filters
      @default_tag_filters ||= Ec2named.config["default_tag_filters"].map do |entry|
        tag_name_value_pair = entry.split(':')
        Filter.strict_tag(tag_name_value_pair[0], tag_name_value_pair[1])
      end
    end

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
          add_filter(Filter.strict_tag(tag_pair[0], tag_pair[1]))
        end
      end
    end

    def validate_aws_env
      errors << "Please provide AWS_REGION or AWS_DEFAULT_REGION" unless ENV['AWS_REGION'] || ENV['AWS_DEFAULT_REGION']
      errors << "Please provide AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY" unless ENV['AWS_SECRET_ACCESS_KEY'] && ENV['AWS_ACCESS_KEY_ID']
    end

    def ec2_client
      @ec2_client ||= Aws::EC2::Client.new
    end

    def filters
      @filters ||= []
    end
  end
end
