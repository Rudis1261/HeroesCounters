# When creating a user we only need a few fields, the reset will be managed through the interface, or through the user journey
# The Form should contain:
# - username (R)
# - email (R)
# - password (R)
# - password_confirmation

# The schema:
# - username
# - email
# - password
# - nonce
# - activated
# - activation_code
# - password_reset
# - locked
# - role

class User < ActiveRecord::Base

  validates :username, presence: true, length: { minumum: 5, maximum: 30 }, uniqueness: true, on: :create
  validates :email, presence: true, uniqueness: true, on: :create
  validates_format_of :email, :with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :password, presence: true
  validates :nonce, presence: true
  validates :email, uniqueness: true
  validates :username, uniqueness: true, on: :create

  # Token auth via session
  def self.sessionAuth(user_id)
    return if user_id.nil?
    User.find(user_id)
  end

  def self.login(params)
    return if params.empty? or params[:password].empty? or params[:username_or_email].empty?
    user = User.where('username=:username_or_email OR email=:username_or_email', username_or_email: params[:username_or_email]).first
    return if user.nil?
    authed = BCrypt::Password.new(user.password) == params[:password] + user.nonce
    if authed
      return true, user
    end
    return false
  end
end