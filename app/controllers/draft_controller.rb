require_relative './application_controller'

class DraftController < ApplicationController
    include Sprockets::Helpers
    include ApplicationHelpers
    include ScraperHelper
    include StorageHelper
    include DraftHelper

    @@default_draft = {
        'blue' => {
            'name' => 'Blue team',
            'bans' => ['',''],
            'ban_count' => 0,
            'picks' => ['','','','',''],
            'pick_count' => 0
        },
        'red' => {
            'name' => 'Red team',
            'bans' => ['',''],
            'ban_count' => 0,
            'picks' => ['','','','',''],
            'pick_count' => 0
        }
    }

    @@draft_order = {
        'team_1' => ['ban', 'pick', 'pick', 'pick', 'ban', 'pick', 'pick'],
        'team_2' => ['ban', 'pick', 'pick', 'ban', 'pick', 'pick', 'pick'],
        'double_picks' => [3, 5, 9, 11]
    }

    get '/draft' do
      session['draft'] ||= {}
      session['draft']['teams'] ||= @@default_draft
      session['draft']['current_team'] ||= nil
      session['draft']['first_pick'] ||= nil
      session['draft']['current_pick'] ||= 0
      session['draft']['picks'] ||= []

      @structure = session['draft']
      @heroes = {}
      @error_messages = session['error_messages']
      session['error_messages'] = nil

      hero_data = JSON.parse(StorageHelper.read_detail_from_disk)
      hero_data.each do |hero|
        @heroes[hero['slug']] = hero
      end

      @current_pick = DraftHelper.next_pick(session,@@draft_order)

      erb :'draft/index', :layout => :'/layouts/draft'
    end

  get '/draft/reset' do
    session['draft'] = {}
    session['draft']['teams'] = @@default_draft
    session['draft']['first_pick'] = nil
    session['draft']['current_team'] = nil
    session['draft']['current_pick'] = nil
    redirect '/draft'
  end

  get '/draft/first_pick/:team' do |team|
    session['draft']['first_pick'] = team
    session['draft']['current_team'] = team
    redirect '/draft'
  end

  get '/draft/:type/:pick' do |type, pick|
    if type == 'pick'
      success = DraftHelper.pick(
          session,
          session['draft']['current_team'],
          pick,
          @@draft_order
      )
    elsif type == 'ban'
      success = DraftHelper.ban(
          session,
          session['draft']['current_team'],
          pick,
          @@draft_order
      )
    end

    if success.nil?
      session['error_messages'] = "That hero is already #{type}#{(pick == 'ban') ? 'ned' : 'ed'}"
    end

    redirect '/draft'
  end
end