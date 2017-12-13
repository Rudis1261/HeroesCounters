require 'rake'
require 'sinatra/activerecord/rake'
require 'rspec/core/rake_task'
require 'securerandom'
#require './app/helpers/auth'

# Active Record Rake Tasks
namespace :db do
  task :load_config do
    require "./app"
  end
end

# RSpec Tests
RSpec::Core::RakeTask.new(:test) do |t|
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

# Custom tasks
task :create_user do

    require "./app"

    print "Username > "
    username = $stdin.gets.chomp

    print "Email > "
    email = $stdin.gets.chomp

    print "Password > "
    password = $stdin.gets.chomp

    print "Role (Default: user) > "
    role = $stdin.gets.chomp

    salt = AuthHelpers::create_salt
    reset_code = AuthHelpers::create_salt
    activation_code = AuthHelpers::create_salt
    hashed_password = AuthHelpers::create_hash(password, salt)

    puts "CREATING USER", "USERNAME: #{username}, EMAIL: #{email}, PASSWORD: #{password}, ROLE: #{role}"
    raise "Invalid details provided" if username.empty? || email.empty? || password.empty? || role.empty?

    user = User.create([
        {
            username: username,
            email: email,
            password: hashed_password,
            nonce: salt,
            activated: 1,
            activation_code: activation_code,
            password_reset: reset_code,
            locked: 0,
            role: role
        }
    ])
    # and "Successfully created user" or "Failed to create user"
end

# Default to RSPEC tests
task :default => :test