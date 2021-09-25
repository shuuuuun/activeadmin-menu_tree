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

        ActiveAdmin.before_load do |aa_config|
          ActiveAdmin::DSL.prepend ActiveAdmin::MenuTree::DSL

          comments_menu = config.find_menu_option(name: "Comment")
          aa_config.comments_menu = comments_menu if comments_menu.present?

          aa_config.namespace :admin do |admin|
            admin.build_menu do |menu|
              config.flattened_menu_options.each do |item|
                next if item[:name] == "Comment"

                options = item.except(:name)
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
