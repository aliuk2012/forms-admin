require "rails_helper"

RSpec.describe Forms::WhatHappensNextForm, type: :model do
  let(:what_happens_next_form) { described_class.new(form:, what_happens_next_markdown:) }
  let(:what_happens_next_markdown) { nil }

  context "when form is live" do
    let(:form) do
      build(:form, :live)
    end

    describe "validations" do
      describe "what_happens_next_markdown" do
        let(:what_happens_next_markdown) { "a" }

        it_behaves_like "a markdown field with headings disallowed" do
          let(:model) { what_happens_next_form }
          let(:attribute) { :what_happens_next_markdown }
        end

        it "is valid if blank" do
          expect(what_happens_next_form).to be_valid
        end
      end
    end

    describe "#submit" do
      it "returns false if the data is invalid" do
        what_happens_next_form.what_happens_next_markdown = "# abc"
        expect(what_happens_next_form.submit).to eq false
      end

      it "sets the form's attribute value" do
        form = OpenStruct.new(what_happens_next_markdown: "abc")
        what_happens_next_form = described_class.new(form:)
        what_happens_next_form.what_happens_next_markdown = "Thank you for submitting"
        what_happens_next_form.submit
        expect(what_happens_next_form.form.what_happens_next_markdown).to eq "Thank you for submitting"
      end
    end
  end

  context "when form is not live" do
    let(:form) do
      build(:form)
    end

    describe "validations" do
      describe "what_happens_next_markdown" do
        let(:what_happens_next_markdown) { "a" }

        it_behaves_like "a markdown field with headings disallowed" do
          let(:model) { what_happens_next_form }
          let(:attribute) { :what_happens_next_markdown }
        end

        it "is valid if blank" do
          expect(what_happens_next_form).to be_valid
        end
      end
    end

    describe "#submit" do
      it "returns false if the data is invalid" do
        what_happens_next_form = described_class.new(form:, what_happens_next_markdown: "# a level one heading")
        expect(what_happens_next_form.submit).to eq false
      end

      it "sets the form's attribute value" do
        form = OpenStruct.new(what_happens_next_markdown: "abc")
        what_happens_next_form = described_class.new(form:)
        what_happens_next_form.what_happens_next_markdown = "Thank you for submitting"
        what_happens_next_form.submit
        expect(what_happens_next_form.form.what_happens_next_markdown).to eq "Thank you for submitting"
      end
    end
  end
end
