class ApplicationController < Sinatra::Base
  include Sprockets::Helpers
  include AuthHelpers
  include ApplicationHelpers
  include ScraperHelper
  include StorageHelper

  set :views, File.expand_path('../../../views', __FILE__)

  before do
    if !env["PATH_INFO"].to_s.include?('/assets/') &&
        !env["PATH_INFO"].to_s.include?('/favicon')
      @user = User.sessionAuth(session[:user_id])
    end
  end

  get '/' do
    content_type :text
    StorageHelper.read_detail_from_disk
  end

   get  '/help' do
    data = {
        '/' => 'All heroes',
        '/help' => 'Displays Help',
        '/hero/<name>' => 'A specific hero by slug',
        '/search/<term>' => 'Find a hero by name'
    }
    JSON.pretty_generate(data)
  end

  ['/hero/:name', '/name/:name'].each do |route|
    get "#{route}" do
      content_type :text
      find_hero_by_name params[:name]
    end
  end

  ['/search/:term', '/find/:term'].each do |route|
    get "#{route}" do
      content_type :text
      search_for_hero_by_term params[:term]
    end
  end

  get '/logoff' do
    session[:nid] = nil
    session[:admin] = nil
    session.clear
    redirect '/'
  end

  get '/login' do
    @redirect = params[:redirect] ||= false
    erb :'login', :layout => :layout, locals: { :errors => {}, :error_messages => [] }
  end

  get '/register' do
    @redirect = params[:redirect] ||= false
    erb :'register', :layout => :layout, locals: { :errors => {}, :error_messages => [] }
  end

  post '/login' do
    errors = {}
    error_messages = []
    if params[:username_or_email].empty? || params[:password].empty?
      if params[:username_or_email].empty?
        errors['username_or_email'] = true
      end
      if params[:password].empty?
        errors['password'] = true
      end
      error_messages << 'Complete the fields'

      erb :'login', :layout => :layout, locals: { :errors => errors, :error_messages => error_messages }
    end

    success, user = User.login(params)
    if !success || !user || !user.id
      error_messages << 'Login failed'
      erb :'login', :layout => :layout, locals: { :errors => errors, :error_messages => error_messages }
    end

    session[:user_id] = user.id
    if params[:redirect]
      redirect params[:redirect]
    end
    redirect '/account'
  end
end