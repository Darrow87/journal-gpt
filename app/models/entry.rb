class Entry < ApplicationRecord
  belongs_to :user

  # Validations
  validates :title, presence: true
  validates :date, presence: true
  validate :validate_content_structure

  # Ensure content is initialized as a hash
  after_initialize :initialize_content, if: :new_record?

  private

  # Initializes content to ensure it's not nil
  def initialize_content
    self.content ||= {}
  end

  # Custom validation to check the structure of the content JSONB field
  def validate_content_structure
    expected_keys = ["challenge", "feelings", "resolution", "chatgpt_response"].sort
    unless content.is_a?(Hash) && (content.keys - expected_keys).empty? && (expected_keys - content.keys).empty?
      errors.add(:content, "must include the correct structure")
    end
  end
  
end
