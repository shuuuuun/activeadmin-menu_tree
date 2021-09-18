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

          config.namespace :admin do |admin|
            admin.build_menu do |menu|
              menu_tree_config = ActiveAdmin::MenuTree.config.menu_tree
              menu_tree_config.each.with_index(1) do |item, index|
                options = item.except(:children, :name)
                options[:label] ||= item[:name]
                options.compact!

                menu.add priority: index * 10, **options do |submenu|
                  next if item[:children].blank?

                  item[:children].each.with_index(1) do |child, child_index|
                    child_options = child.except(:children, :name)
                    next if child[:name]

                    submenu.add priority: child_index, **child_options
                  end
                end
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
