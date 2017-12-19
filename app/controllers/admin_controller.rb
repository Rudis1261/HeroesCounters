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
      @hero_slugs = hero_slugs
    end

    get '/admin' do
      admin_required
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/scrape' do
      admin_required
      scrape = scrape_heroes
      @message = scrape.size > 0 ? "Scape completed" : "Something went wrong. No data was received"
      @json_data = scrape
      first_entry = JSON.parse(@json_data).first.to_json
      @json_data_escaped = URI.escape(first_entry)
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/scrape/detail' do
      admin_required
      scrape = scrape_heroes_detail
      @message =  "Detail scape initiated"
      #@json_data = scrape
      #@json_data_escaped = URI.escape(JSON.parse(@json_data).to_json)
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/parse/detail' do
      admin_required
      scrape = ScraperHelper.parse_hero_details_and_save_to_disk
      @message = scrape ? "Parsed hero details" : "Something went wrong. Unable to parse details"
      erb :'admin/index', :layout => :'/layouts/main'
    end

    get '/admin/hero' do
      admin_required
      erb :'admin/index', :layout => :'/layouts/main'
    end

    post '/admin/hero' do
      admin_required
      if params[:action] && params[:action] == 'scrape'
        scrape_hero(params[:hero])
        @message = "Scaping #{params[:hero].capitalize}"
      end

      if params[:action] && params[:action] == 'insert'
        @message = 'insert something'
      end

      if params[:action] && params[:action] == 'images'
        @message = "Get them images something<br/><br/>"
        @hostname = ApplicationController.get_hostname_from_request(request)
        @json_data = ImageHelper.get_images_from_hero(StorageHelper.read_hero_from_disk(params[:hero]))

        # DEBUGGING
        @message += ImageHelper.local_image_url(@hostname, @json_data[:bust], {:hero => params[:hero]}) + '<br>'
        @json_data[:abilities].each do |image|
          options = {:hero => params[:hero], :type => 'abilities'}
          @message += ImageHelper.local_image_url(@hostname, image, options) + '<br>'
        end
        # DEBUGGING
      end

      erb :'admin/index', :layout => :'/layouts/main'
    end
end