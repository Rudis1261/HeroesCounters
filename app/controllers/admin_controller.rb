require_relative './application_controller'

class AdminController < ApplicationController
    include Sprockets::Helpers
    include ApplicationHelpers
    include ScraperHelper
    include StorageHelper
    include ImageHelper

    @message
    @json_data
    @json_data_escaped

    before do
      if request.path_info.include?('/admin')
        admin_required
      end

      @hero_slugs = hero_slugs
    end

    get '/admin' do
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/scrape' do
      scrape = scrape_heroes
      @message = scrape.size > 0 ? "Scape completed" : "Something went wrong. No data was received"
      @json_data = scrape
      first_entry = JSON.parse(@json_data).first.to_json
      @json_data_escaped = URI.escape(first_entry)
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/scrape/detail' do
      scrape_heroes_detail
      @message =  "Detail scape initiated"
      #@json_data = scrape
      #@json_data_escaped = URI.escape(JSON.parse(@json_data).to_json)
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/parse/detail' do
      scrape = ScraperHelper.parse_hero_details_and_save_to_disk
      @message = scrape ? "Parsed hero details" : "Something went wrong. Unable to parse details"
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/hero' do
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/purge' do
      erb :'admin/purge', :layout => :'/layouts/main'
    end

    get '/admin/purge/json' do
      @message = "Purging JSON"
      StorageHelper.purge
      erb :'admin/purge', :layout => :'/layouts/main'
    end

    get '/admin/purge/json-detail' do
      @message = "Purging detail JSON"
      StorageHelper.purge_detail
      erb :'admin/purge', :layout => :'/layouts/main'
    end

    get '/admin/purge/json-all' do
      @message = "Purging all JSON files"
      StorageHelper.purge_all
      erb :'admin/purge', :layout => :'/layouts/main'
    end

    get '/admin/purge/images' do
      @message = "Purge images"
      ImageHelper.purge
      erb :'admin/purge', :layout => :'/layouts/main'
    end

    post '/admin/hero' do
      if params[:action] && params[:action] == 'scrape'
        scrape_hero(params[:hero])
        @message = "Scaping #{params[:hero].capitalize}"
      end

      if params[:action] && params[:action] == 'insert'
        @message = 'insert something'
      end

      if params[:action] && params[:action] == 'images'
        @message = "Get them images something<br/><br/>"
        hero_images = ImageHelper.get_images_from_hero(StorageHelper.read_hero_from_disk(params[:hero]))

        ImageHelper.create_hero_image_directories params[:hero]

        hero_images.each do |image|
          @message += "#{ImageHelper.pull_image(params[:hero], image)}<br>"
        end
      end

      erb :'admin/index', :layout => :'/layouts/main'
    end
end