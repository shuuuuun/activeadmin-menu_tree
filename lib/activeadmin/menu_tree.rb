# frozen_string_literal: true

require_relative "menu_tree/version"
require_relative "menu_tree/config"
require_relative "menu_tree/dsl"

module ActiveAdmin
  module MenuTree
    class Error < StandardError; end

    class << self
      attr_accessor :config

      def setup
        yield(config)
      end

      def config
        @config ||= Config.new
      end

      # def setup(&block)
      #   @config ||= Config.new(&block)
      # end
    end

    # def self.setup(&block)
    #   @config ||= Config.new(&block)
    # end
  end
end
