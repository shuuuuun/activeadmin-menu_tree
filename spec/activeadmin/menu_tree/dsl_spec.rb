# frozen_string_literal: true

require "active_admin/dsl"

RSpec.describe ActiveAdmin::MenuTree::DSL do
  ActiveAdmin::DSL.prepend ActiveAdmin::MenuTree::DSL

  let(:dsl) { ActiveAdmin::DSL.new(config) }
  let(:config) { double("ActiveAdmin::Application") }

  describe "menu_tree" do
    subject { dsl.menu_tree }

    let(:resource_name) { double("ActiveAdmin::Resource::Name") }

    before do
      allow(config).to receive(:resource_name).and_return(resource_name)
      allow(resource_name).to receive(:name).and_return("name")
      allow(dsl).to receive(:config).and_return(config)
      allow(dsl).to receive(:menu)
      allow(ActiveAdmin::MenuTree).to receive(:config).and_call_original
      subject
    end

    it { expect(dsl).to have_received(:menu) }
    it { expect(ActiveAdmin::MenuTree).to have_received(:config) }
  end
end
