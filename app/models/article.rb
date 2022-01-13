class Article < ApplicationRecord
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
  validates :topic,  presence: true, inclusion: { in: %w(others movies gaming books sports)}
  validates :previous_version_date_cannot_be_in_the_future
                
  before_update :update_previous_version_date, unless: :updated_at_changed?
  before_validation :ensure_topic_has_a_value, on: :create
                    
  private
    def update_previous_version_date
      self.previous_version_date = updated_at
    end       
    
    def previous_version_date_cannot_be_in_the_future
      if previous_version_date.present? && previous_version_date > Date.today
        errors.add(:expiration_date, "can't be in the future")
      end
    end

    def ensure_topic_has_a_value
      self.topic = "others" if topic.nil?
    end

end
