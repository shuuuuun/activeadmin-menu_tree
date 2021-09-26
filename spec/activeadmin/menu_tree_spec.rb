# frozen_string_literal: true

RSpec.describe ActiveAdmin::MenuTree do
  it "has a version number" do
    expect(ActiveAdmin::MenuTree::VERSION).not_to be nil
  end

  describe "setup" do
    subject { ActiveAdmin::MenuTree.setup(&block) }

    let(:block) { lambda { |config| config.menu_tree = [] } }
    let(:activeadmin_config) { double("ActiveAdmin::Application") }

    before do
      allow(activeadmin_config).to receive(:comments_menu=)
      allow(activeadmin_config).to receive(:namespace)
      allow(ActiveAdmin).to receive(:before_load).and_yield(activeadmin_config)
      allow(ActiveAdmin::DSL).to receive(:prepend)
    end

    it { expect{ subject }.not_to raise_error }
    it { expect{ |b| ActiveAdmin::MenuTree.setup(&b) }.to yield_with_args(ActiveAdmin::MenuTree.config) }

    context do
      before { subject }

      it { expect(ActiveAdmin).to have_received(:before_load).once }
      it { expect(ActiveAdmin::DSL).to have_received(:prepend).with(ActiveAdmin::MenuTree::DSL).once }
      it { expect(activeadmin_config).to have_received(:namespace).once }
    end

    context "with Comment" do
      before { subject }
      let(:block) { lambda { |config| config.menu_tree = [{ name: "Comment" }] } }

      it { expect(activeadmin_config).to have_received(:comments_menu=).once }
    end

    context "no block given" do
      let(:block) { nil }

      it { expect{ subject }.to raise_error ActiveAdmin::MenuTree::Error }
    end
  end

  describe "config" do
    subject { ActiveAdmin::MenuTree.config }

    it { is_expected.not_to be_nil }
    it { is_expected.to be_kind_of(ActiveAdmin::MenuTree::Config) }
  end
end
