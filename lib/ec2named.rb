# encoding: utf-8
# frozen_string_literal: true

require 'aws-sdk'
require 'json'
require 'trollop'
require 'monkey_patches/io'
require 'pp'
require 'yaml'

require "ec2named/version"
require "ec2named/config"
require "ec2named/filter"
require "ec2named/instance"
require "ec2named/query"
require "ec2named/cli"

module Ec2named
  def config
    @config ||= Ec2named::Config.new.look("#{Dir.home}/.ec2named.yml").load
  end
  module_function :config
end