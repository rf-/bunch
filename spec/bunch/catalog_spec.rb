# encoding: utf-8

require "spec_helper"

module Bunch
  describe Catalog do
    describe "#node_for_file" do
      let(:catalog) { Catalog.new }

      describe "when there is one matching type" do
        let(:non_matching_type) { stub(:matches? => false) }
        let(:matching_type) { stub(:matches? => true) }

        before do
          catalog.register non_matching_type
          catalog.register matching_type
        end

        it "returns an instance of the first matching node type" do
          matching_type.expects(:new).with("foo_bar.js").returns(:object)

          catalog.node_for_path("foo_bar.js").must_equal :object
        end
      end

      describe "when there are no matching types" do
        let(:non_matching_type) { stub(:matches? => false) }
        let(:other_non_matching_type) { stub(:matches? => false) }

        before do
          catalog.register non_matching_type
          catalog.register other_non_matching_type
        end

        it "returns nil" do
          catalog.node_for_path("foo_bar.js").must_equal nil
        end
      end
    end
  end
end