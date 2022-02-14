# frozen_string_literal: true

module ActiveAdmin
  module MenuTree
    # ActiveAdmin::MenuTree::Logging module
    module Logging
      def debug?
        ENV["MENU_TREE_DEBUG"]
      end

      def log_debug(message)
        warn("[ActiveAdmin::MenuTree] #{message}") if debug?
      end

      def warn_deprecated(message)
        warn("[ActiveAdmin::MenuTree] [DEPRECATION] #{message}")
      end
    end
  end
end
