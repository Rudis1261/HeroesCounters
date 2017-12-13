require_relative './application_controller'

class AdminController < ApplicationController
    include Sprockets::Helpers
    include ApplicationHelpers
    include ScraperHelper

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

    get '/admin/scrape/:hero' do
      admin_required
      scrape = scrape_hero(params[:hero])
      @message = scrape.size > 0 ? "Scape completed" : "Something went wrong. No data was received"
      @json_data = scrape
      @json_data_escaped = URI.escape(JSON.parse(@json_data).to_json)
      erb :'admin/index'
    end

    get '/admin/scrape-heroes' do
      admin_required
      @message = scrape_hero_details ? "Scape completed" : "Something went wrong. No data was received"
      erb :'admin/index'
    end

    get '/admin/parse-details' do
      admin_required
      @message = parse_hero_details_and_save_to_disk ? "Parse completed" : "Something went wrong. Could not parse details"
      erb :'admin/index'
    end
end