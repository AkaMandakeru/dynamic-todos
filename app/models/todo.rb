class Todo < ApplicationRecord
  validates :title, presence: true
  validates :completed, inclusion: { in: [ true, false ] }

  belongs_to :parent, class_name: "Todo", optional: true
  has_many :subtasks, class_name: "Todo", foreign_key: "parent_id", dependent: :destroy

  scope :root_tasks, -> { where(parent_id: nil) }
  scope :pending, -> { where(completed: false) }
  scope :completed, -> { where(completed: true) }
end
