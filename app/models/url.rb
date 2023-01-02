# frozen_string_literal: true

class Url < ApplicationRecord
  has_many :clicks
  scope :latest, -> {order('id desc')}
  # validates :short_url,
    # presence: true,
    # length: { maximum: 5 },
    # uniqueness: true,
    # format: { with: /\A[A-Z]+\z/ }

  validates :original_url,
    presence: true,
    format: URI::DEFAULT_PARSER.make_regexp(%w[http https])

  before_save :shorten_url
  def shorten_url
    self.short_url = [*('A'..'Z')].sample(5).join if new_record?
  end
end
