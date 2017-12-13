require_relative './application_controller'

class AccountController < ApplicationController
  include Sprockets::Helpers
  include ApplicationHelpers

  get '/account' do
    login_required
    erb :'account/index'
  end
end