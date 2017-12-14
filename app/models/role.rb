# The schema:
# 'role' => {
#   'name' => hero['role']['name'],
#   'slug' => hero['role']['slug'],
#   'description' => hero['role']['description'],
# },

class Role < ActiveRecord::Base
  belongs_to :hero

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, on: :create
  validates :description, presence: true
end