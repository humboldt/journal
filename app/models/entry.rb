class Entry < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
end
