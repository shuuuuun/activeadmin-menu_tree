# frozen_string_literal: true

require "active_admin/dsl"

RSpec.describe ActiveAdmin::MenuTree::DSL do
  ActiveAdmin::DSL.prepend ActiveAdmin::MenuTree::DSL

  let(:dsl) { ActiveAdmin::DSL.new(config) }
  let(:config) { instance_double("ActiveAdmin::Application") }

  describe "menu_tree" do
    subject { dsl.menu_tree }

    let(:resource_name) { instance_double("ActiveAdmin::Resource::Name") }

    before do
      allow(config).to receive(:resource_name).and_return(resource_name)
      allow(resource_name).to receive(:name).and_return("name")
      allow(dsl).to receive(:config).and_return(config)
      allow(dsl).to receive(:menu)
      allow(ActiveAdmin::MenuTree).to receive(:config).and_call_original
      allow(ActiveAdmin::MenuTree.config).to receive(:find_menu_option)
      subject
    end

    it { expect(dsl).to have_received(:menu).with(no_args).once }
    it { expect(ActiveAdmin::MenuTree).to have_received(:config).at_least(:once) }
    it { expect(ActiveAdmin::MenuTree.config).to have_received(:find_menu_option).with(id: "name").once }

    context "with args" do
      subject { dsl.menu_tree(**kwargs) }
      let(:kwargs) { { label: "label", priority: 999, foo: "foo" } }

      it { expect(dsl).to have_received(:menu).with(kwargs).once }
      it { expect(ActiveAdmin::MenuTree).to have_received(:config).at_least(:once) }
      it { expect(ActiveAdmin::MenuTree.config).to have_received(:find_menu_option).with(id: "name").once }
    end
  end
end
