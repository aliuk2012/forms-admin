require "govuk_forms_markdown"

class Pages::GuidanceForm < BaseForm
  include GuidanceValidation

  attr_accessor :page_heading, :guidance_markdown, :draft_question

  validates :draft_question, presence: true

  def submit
    return false if invalid?

    draft_question
      .assign_attributes({ page_heading:, guidance_markdown: })

    draft_question.save!(validate: false)
  end
end
