# frozen_string_literal: true

RSpec.describe ActiveAdmin::MenuTree::DSL do
  let(:dummy) { Class.new { extend ActiveAdmin::MenuTree::DSL } }

  describe "menu_tree" do
    subject { dummy.menu_tree }

    let(:config) { double("ActiveAdmin::Application") }
    let(:resource_name) { double("ActiveAdmin::Resource::Name") }

    before do
      allow(config).to receive(:resource_name).and_return(resource_name)
      allow(resource_name).to receive(:name).and_return("name")
      allow(dummy).to receive(:config).and_return(config)
      allow(dummy).to receive(:menu)
      allow(ActiveAdmin::MenuTree).to receive(:config).and_call_original
      subject
    end

    it { expect(dummy).to have_received(:menu) }
    it { expect(ActiveAdmin::MenuTree).to have_received(:config) }
  end
end
