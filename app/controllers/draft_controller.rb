require_relative './application_controller'

class DraftController < ApplicationController
    include Sprockets::Helpers
    include ApplicationHelpers
    include ScraperHelper
    include StorageHelper
    include ImageHelper

    get '/draft' do
      @data = {
        :red => {
          :name => 'Red team',
          :bans => ['',''],
          :picks => ['','','','','']
        },
        :blue => {
          :name => 'Blue team',
          :bans => ['',''],
          :picks => ['','','','','']
        }
      }

      heroes = JSON.parse(StorageHelper.read_detail_from_disk)

      heroes.shuffle.first(2).each_with_index do |hero, index|
        @data[:blue][:bans][index] = hero
      end

      heroes.shuffle.first(2).each_with_index do |hero, index|
        @data[:red][:bans][index] = hero
      end

      heroes.shuffle.first(5).each_with_index do |hero, index|
        @data[:blue][:picks][index] = hero
      end

      heroes.shuffle.first(5).each_with_index do |hero, index|
        @data[:red][:picks][index] = hero
      end

      erb :'draft/index', :layout => :'/layouts/draft'
    end
end