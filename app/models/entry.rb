class Entry
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :title, :body, :date, :user

  validates :title, presence: true
  validates :body, presence: true
  validates :date, presence: true

  def initialize(attributes = {})
    @title = attributes[:title]
    @body = attributes[:body]
    @date = attributes[:date]
    @user = attributes[:user]
  end

  def submit
    if valid?
      # Here you would make the API call to ChatGPT with the entry data
      # For example: ChatGPTService.generate_response(self)
      true
    else
      false
    end
  end
end
