require 'bcrypt'
require 'securerandom'

module AuthHelpers
  def self.create_salt
    SecureRandom.uuid()
  end

  def self.create_hash(password, salt = nil)
    salt = salt ||= AuthHelpers.create_salt

    BCrypt::Password.create(password + salt, cost: 13)
  end

  def self.restore_hash(stored_hash)
    BCrypt::Password.new stored_hash
  end

  def self.compare_hash(password, salt, stored_hash)
    AuthHelpers.restore_hash(stored_hash) == password + salt
  end
end