# The schema:
# 'name' => hero['name'],
# 'slug' => hero['slug'],
# 'title' => hero['title'],
# 'description' => hero['baseHeroInfo']['role']['description'] ||= hero['role']['description'],
# 'type' => hero['baseHeroInfo']['type']['name'] ||= hero['type']['name'],
# 'franchise' => hero['franchise'],
# 'difficulty' => hero['difficulty'],
# 'live' => hero['revealed'],
# 'poster_image' => ConfigController.image_urls['bust'] % hero['slug'],
# 'stats' => @stats,
# 'trait' => @data['trait'],
# 'abilities' => @data['abilities'],
# 'heroics' => @data['heroics'],

class Hero < ActiveRecord::Base
    has_one :roles
    has_many :stats
    has_many :traits
    has_many :abilities
    has_many :heroics

    validates :name, presence: true, uniqueness: true, on: :create
    validates :slug, presence: true, uniqueness: true, on: :create
    validates :title, presence: true
    validates :description, presence: true
    validates :type, presence: true
    validates :franchise, presence: true
    validates :difficulty, presence: true
    validates :live, presence: true
    validates :poster_image, presence: true
end