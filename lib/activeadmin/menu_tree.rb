# frozen_string_literal: true

require "active_support"
require "active_support/core_ext"

require_relative "menu_tree/version"
require_relative "menu_tree/logging"
require_relative "menu_tree/config"
require_relative "menu_tree/dsl"

module ActiveAdmin
  # ActiveAdmin::MenuTree class
  module MenuTree
    class Error < StandardError; end

    class << self
      include ActiveAdmin::MenuTree::Logging

      def setup
        raise ActiveAdmin::MenuTree::Error, "No block given, require a block" unless block_given?

        yield(config)

        ActiveAdmin.before_load do |aa_config|
          ActiveAdmin::DSL.prepend ActiveAdmin::MenuTree::DSL

          setup_menu_options(aa_config)
        end
      end

      def config
        @config ||= Config.new
      end

      private

      def setup_menu_options(aa_config)
        comments_menu = config.find_menu_option(id: "Comment")
        aa_config.comments_menu = comments_menu if comments_menu.present?

        menu_options = config.menu_options
                             .reject{ |item| item[:id] == "Comment" }

        ActiveAdmin::MenuTree.log_debug("menu_options: #{menu_options.inspect}")
        aa_config.namespace :admin do |admin|
          admin.build_menu do |menu|
            menu_options.each do |options|
              menu.add(**options)
            end
          end
        end
      end
    end
  end
end
