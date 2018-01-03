require_relative './application_controller'

class DraftController < ApplicationController
    include Sprockets::Helpers
    include ApplicationHelpers
    include ScraperHelper
    include StorageHelper
    include DraftHelper

    get '/draft' do
      @data = {
        :blue => {
          :name => 'Blue team',
          :bans => ['',''],
          :picks => ['','','','','']
        },
        :red => {
          :name => 'Red team',
          :bans => ['',''],
          :picks => ['','','','','']
        }
      }

      @draft = session[:draft] ||= DraftHelper.default_draft
      @heroes = JSON.parse(StorageHelper.read_detail_from_disk)

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

  get '/draft/reset' do
    session[:draft] = DraftHelper.default_draft
    redirect '/draft'
  end

  get '/draft/first_pick/:team' do |team|
    if !session[:draft]
      session[:draft] = {}
    end

    session[:draft][:first_pick] = team.to_s
    redirect '/draft'
  end

  get '/draft/pick/:pick' do |pick|
    DraftHelper.pick(session, pick)
    redirect '/draft'
  end
end