# frozen_string_literal: true

module ActiveAdmin::MenuTree
  # module Config
  class Config
    # @config = {
    #   menu_tree_hash: [],
    # }
    attr_accessor :menu_tree

    # def initialize(&block)
    #   instance_exec(self, &block)
    # end

    # class << self
    #   def menu_tree_hash=(arg)
    #     @config[:menu_tree_hash] = arg
    #   end

    #   def menu_tree_hash
    #     @config.fetch(:menu_tree_hash)
    #   end
    # end
  end
end
