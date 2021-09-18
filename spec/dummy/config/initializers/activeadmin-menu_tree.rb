ActiveAdmin::MenuTree.setup do |config|
  config.menu_tree = YAML.load_file(Rails.root.join("../support/config.yml"))["activeadmin"]["menu_tree"]
  # config.menu_tree = [
  #   {
  #     name: "Dashboard"
  #   }, {
  #     label: "User",
  #     children: [{
  #       name: "User"
  #     }]
  #   }, {
  #     label: "Other",
  #     children: [{
  #       name: "Foo"
  #     }, {
  #       name: "Bar"
  #     }]
  #   }, {
  #     label: "Admin",
  #     children: [{
  #       name: "AdminUser",
  #       label: "Admin Users"
  #     }, {
  #       name: "Comment",
  #       label: "Admin Comments",
  #       url: "/admin/comments"
  #     }]
  #   }, {
  #     label: "Site",
  #     url: "https://example.com",
  #     html_options: {
  #       target: "blank"
  #     }
  #   }
  # ]
end
