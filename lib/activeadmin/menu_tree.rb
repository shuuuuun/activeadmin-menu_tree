# frozen_string_literal: true

require_relative "menu_tree/version"
require_relative "menu_tree/config"
require_relative "menu_tree/dsl"

module ActiveAdmin
  module MenuTree
    class Error < StandardError; end

    class << self
      def setup
        yield(config)

        ActiveAdmin.before_load do |config|
          ActiveAdmin::DSL.prepend ActiveAdmin::MenuTree::DSL

          menu_tree_config = ActiveAdmin::MenuTree.config

          comments_menu = menu_tree_config.find_menu_option(name: "Comment")
          config.comments_menu = comments_menu if comments_menu.present?

          config.namespace :admin do |admin|
            admin.build_menu do |menu|
              menu_tree_config.flatten_menu_options.each do |item|
                options = item.except(:name)
                options[:label] ||= item[:name]&.pluralize&.titleize
                options.compact!

                menu.add(**options)
              end
            end
          end
        end
      end

      def config
        @config ||= Config.new
      end
    end
  end
end
