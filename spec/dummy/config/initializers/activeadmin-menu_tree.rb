ActiveAdmin::MenuTree.setup do |config|
  config.menu_tree = YAML.load_file(Rails.root.join("../support/config.yml"))["activeadmin"]["menu_tree"]
  # config.menu_tree = YAML.load_file(Rails.root.join("../support/config.yml"))["activeadmin"]["menu_tree_flat"]
end
