# The schema:
# 'name' => '',
# 'description' => '',
# 'slug' => '',
# 'image' => ''

class Ability < ActiveRecord::Base
  belongs_to :hero

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true, on: :create
  validates :description, presence: true
  validates :image, presence: true
end