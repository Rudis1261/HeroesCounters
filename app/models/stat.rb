# The schema:
# 'damage' => hero['stats']['damage'] ||= 0,
# 'utility' => hero['stats']['utility'] ||= 0,
# 'survivability' => hero['stats']['survivability'] ||= 0,
# 'complexity' => hero['stats']['complexity'] ||= 0

class Stat < ActiveRecord::Base
  belongs_to :hero

  validates :damage, presence: true
  validates :utility, presence: true
  validates :survivability, presence: true
  validates :complexity, presence: true
end