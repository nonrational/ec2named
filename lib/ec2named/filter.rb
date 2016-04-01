# encoding: utf-8
# frozen_string_literal: true

module Ec2named
  module Filter
    def self.type(value)
      {
        name: "instance-type",
        values: [value.to_s]
      }
    end

    def self.id(value)
      {
        name: "instance-id",
        values: [value.to_s]
      }
    end

    def self.key_name(value)
      {
        name: "key-name",
        values: [value.to_s]
      }
    end

    def self.tag(tag_name, tag_value)
      {
        name: "tag:#{tag_name}",
        values: ["*#{tag_value}*"]
      }
    end

    def self.all
      {
        name: "tag:Name",
        values: ["*"]
      }
    end

    def self.tag_status_in_use
      tag("status", "in-use")
    end

    def self.tag_status_zombie
      tag("status", "zombie")
    end
  end
end
