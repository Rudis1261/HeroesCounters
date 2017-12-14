require_relative './application_controller'

class AdminController < ApplicationController
    include Sprockets::Helpers
    include ApplicationHelpers
    include ScraperHelper
    include StorageHelper

    @message
    @json_data
    @json_data_escaped

    before do
      @hero_slugs = hero_slugs
    end

    get '/admin' do
      admin_required
      erb :'admin/index'
    end

    get '/admin/scrape' do
      admin_required
      scrape = scrape_heroes
      @message = scrape.size > 0 ? "Scape completed" : "Something went wrong. No data was received"
      @json_data = scrape
      first_entry = JSON.parse(@json_data).first.to_json
      @json_data_escaped = URI.escape(first_entry)
      erb :'admin/index'
    end

    get '/admin/scrape/detail' do
      admin_required
      scrape = scrape_heroes_detail
      @message = scrape ? "Detail scape completed" : "Something went wrong. No data was received"
      @json_data = scrape
      @json_data_escaped = URI.escape(JSON.parse(@json_data).to_json)
      erb :'admin/index'
    end

    get '/admin/parse/detail' do
      admin_required
      scrape = ScraperHelper.parse_hero_details_and_save_to_disk
      @message = scrape ? "Parsed hero details" : "Something went wrong. Unable to parse details"
      erb :'admin/index'
    end

    get '/admin/hero' do
      admin_required
      erb :'admin/index'
    end

    post '/admin/hero' do
      admin_required
      if params[:action] && params[:action] == 'scrape'
        scrape = scrape_hero(params[:hero])
        @message = scrape.size > 0 ? "Scape completed" : "Something went wrong. No data was received"
        @json_data = scrape
        @json_data_escaped = URI.escape(JSON.parse(@json_data).to_json)
      end

      if params[:action] && params[:action] == 'insert'
        @message = 'insert something'
        #@message = ScraperHelper.parse_hero_details_and_save_to_disk ? "Parse completed" : "Something went wrong. Could not parse details"
      end

      erb :'admin/index'
    end
end