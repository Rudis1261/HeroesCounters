require 'spec_helper'

describe AuthHelpers do
  subject do
    Class.new { include AuthHelpers }
  end

  before :each do
    @salt = '27cfb271-aa1e-499f-95dd-fee35fd8060e'
    @password = 'test password'
    @stored_hash = '$2a$10$ZyAeBMXNyOQLaPmGNBHQYeAGk8xDZDBvpUjMV.LBmrgLdz17nK8U.'

    @restored_hash = AuthHelpers.restore_hash @stored_hash
    @compare_hash = AuthHelpers.compare_hash(@password, @salt, @stored_hash)
  end

  it 'Should generate a salt of 36 chars long' do
    expect(AuthHelpers.create_salt.size).to eq(36)
  end

  it 'Should generate a hash based on a salt + password' do
    expect(AuthHelpers.create_hash 'test').to be_an_instance_of BCrypt::Password
  end

  it 'Should be able to compare restored hashes manually' do
    expect(@restored_hash).to eq(@password + @salt)
  end

  it 'Should be able do a comparison' do
    expect(@compare_hash).to be true
  end
end