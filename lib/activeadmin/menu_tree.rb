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
    end
  end
end

ActiveAdmin.before_load do |config|
  ActiveAdmin::DSL.prepend ActiveAdmin::MenuTree::DSL

  menu_tree_config = ActiveAdmin::MenuTree.config.menu_tree

  config.namespace :admin do |admin|
    admin.build_menu do |menu|
      menu_tree_config.each.with_index(1) do |item, index|
        options = item.except(:children)
        options[:label] ||= item[:name]
        # pp options
        menu.add priority: index * 10, **options
        # menu.add label: item[:label], priority: index * 10, **options

        # next if item[:children].blank?
        # item[:children].each.with_index(1) do |child, child_index|
        #   child_options = child.except(:children)
        #   menu.add parent: item[:label], label: child[:label], priority: child_index, **child_options
        # end

        # menu.add label: item[:label], priority: index * 10, **options do |submenu|
        #   next if item[:children].blank?
        #   item[:children].each.with_index(1) do |child, child_index|
        #     child_options = child.except(:children)
        #     submenu.add label: child[:label], priority: child_index, **child_options
        #   end
        # end
      end
    end
  end
end
