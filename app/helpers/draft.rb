module DraftHelper
  def self.ban(session, team, ban, draft_order)
    return if session['draft']['picks'].include?(ban)
    index = session['draft']['teams'][team]['ban_count']
    session['draft']['teams'][team]['bans'][index] = ban
    session['draft']['teams'][team]['ban_count'] = index + 1
    session['draft']['picks'] << ban
    self.push_state(session, team, draft_order)
  end

  def self.pick(session, team, pick, draft_order)
    return if session['draft']['picks'].include?(pick)
    index = session['draft']['teams'][team]['pick_count']
    session['draft']['teams'][team]['picks'][index] = pick
    session['draft']['teams'][team]['pick_count'] = index + 1
    session['draft']['picks'] << pick
    self.push_state(session, team, draft_order)
  end

  def self.next_pick(session, draft_order)
    current_team = session['draft']['current_team']
    first_pick = session['draft']['first_pick']
    current_pick = session['draft']['current_pick']
    team = (current_team == first_pick) ? 'team_1' : 'team_2'
    step = (current_pick / 2).ceil
    type = draft_order[team][step]
    count_type = (type == 'ban') ? 'ban_count' : 'pick_count'
    current_index = current_team ? session['draft']['teams'][current_team][count_type]: 0

    {
        'team' => current_team,
        'type' => type,
        'index' => current_index
    }
  end

  def self.push_state(session, team, draft_order)
    if !draft_order['double_picks'].include?(session['draft']['current_pick'])
      session['draft']['current_team'] = (team == 'red') ? 'blue' : 'red'
    end
    session['draft']['current_pick'] += 1
  end
end