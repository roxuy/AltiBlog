# frozen_string_literal: true

class Article < ApplicationRecord
  # scope :filter_by_topic, -> (topic) { where("topic = ?",topic ) }
  scope :filter_by_topic, ->(topic) { where topic: topic }
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
  validates :topic, presence: true, inclusion: { in: %w[others movies gaming books sports] }
  validate :previous_version_date_cannot_be_in_the_future

  before_save :update_previous_version_date, unless: :updated_at_changed?
  scope :filter_by_topic, ->(topic) { where topic: topic }
  private

  def update_previous_version_date
    self.previous_version_date = updated_at
  end

  def previous_version_date_cannot_be_in_the_future
    return unless previous_version_date.present? && previous_version_date > Date.today

    errors.add(:expiration_date, "can't be in the future")
  end
end
