class Task < ApplicationRecord
    validates :title, presence: true

    scope :todo, -> { where(completed: false).order(created_at: :desc) }
    scope :completed, -> { where(completed: true).order(created_at: :desc) }
end
