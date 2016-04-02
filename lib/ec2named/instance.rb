# encoding: utf-8
# frozen_string_literal: true

module Ec2named
  class Instance
    attr_reader :id, :type, :name, :status, :ip, :key_name, :age

    def initialize(raw_instance)
      @id = raw_instance.instance_id
      @type = raw_instance.instance_type
      @ip = first_private_ip(raw_instance) || "(#{raw_instance.state.name})"
      @key_name = raw_instance.key_name
      @age = InstanceAge.new(raw_instance.launch_time)
      raw_instance.tags.each { |tag| tags[tag.key] = tag.value }
    end

    def print(verbose)
      STDOUT.print ip
      if verbose
        STDERR.print "#{verbose_description}\n"
      else
        STDOUT.print "\n"
      end
      STDERR.flush
      STDOUT.flush
    end

    private

    def verbose_description
      verbose_description = "\t[#{id}, #{key_name}, #{age}, "

      common_tags.each_with_index do |tag, i|
        verbose_description += "#{tag[0]}:#{tag[1]}"
        verbose_description += ", " unless i == common_tags.size - 1
      end

      verbose_description += "]"
    end

    def common_tags
      @common_tags ||= tags.sort.reject { |tag| reject_tag_prefixes.any? { |reject| tag[0].start_with?(reject) } }
    end

    def reject_tag_prefixes
      Ec2named.config["reject_tag_prefixes"]
    end

    def name
      @name ||= tags["Name"]
    end

    def tags
      @tags ||= {}
    end

    def first_private_ip(raw_instance)
      unless raw_instance.network_interfaces.empty?
        raw_instance.network_interfaces.first
                    .private_ip_addresses.first.private_ip_address
      end
    end
  end
end
