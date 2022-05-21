# frozen_string_literal: true

class Article < ApplicationRecord
  scope :filter_by_topic, ->(topic) { where topic: topic }
  #scope :filter_by_previous_version_range, lambda { |start_date, end_date|
  #                                           where('previous_version_date BETWEEN ? AND ?', start_date, end_date)
  #                                         }
  scope :filter_by_previous_version_range, lambda { |date1, date2| where(["date(previous_version_date) between ? and ?", date1, date2]) }
  has_many :comments, dependent: :destroy
  validates :title, presence: true,
                    length: { minimum: 5 }
  validates :topic, presence: true, inclusion: { in: %w[others movies gaming books sports] }
  validate :previous_version_date_cannot_be_in_the_future

  before_save :update_previous_version_date

  private

  def update_previous_version_date
    self.previous_version_date = updated_at
  end

  def previous_version_date_cannot_be_in_the_future
    return unless previous_version_date.present? && previous_version_date > Date.today

    errors.add(:expiration_date, "can't be in the future")
  end
end
