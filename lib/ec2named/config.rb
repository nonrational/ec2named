# encoding: utf-8
# frozen_string_literal: true

module Ec2named
  class Config
    def look(path)
      load_paths << path
      self
    end

    def load
      load_paths.each_with_object(default_config) do |path, obj|
        obj.merge!(YAML.load(File.read(path))) if File.exist?(path)
      end
    end

    def default_config
      {
        "reject_tag_prefixes" => [],
        "environments" => [],
        "default_tag_filters" => [],
        "application_tag" => 'app',
        "environment_tag" => 'env'
      }
    end

    def load_paths
      @load_paths ||= []
    end
  end
end
