class Question < ApplicationRecord
  include Linkable
  include Votable

  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribed_users, through: :subscriptions, source: :user

  belongs_to :user

  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true

  after_create :calculate_reputation, :subscribe_author!

  scope :created_prev_day, -> { where(created_at: Date.today.prev_day.all_day) }

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def subscribe_author!
    subscribed_users << user
  end
end
