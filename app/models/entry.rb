class Entry < ApplicationRecord
  # Association
  belongs_to :user
  
  # Validations
  validates :title, presence: true
  validates :body, presence: true
  validates :date, presence: true
end
