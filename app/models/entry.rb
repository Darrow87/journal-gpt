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
    unless content.is_a?(Hash) && content.keys.sort == ["challenge", "feelings", "resolution"].sort
      errors.add(:content, "must include the correct structure")
    end
  end
end
