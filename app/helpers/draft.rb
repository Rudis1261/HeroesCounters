module DraftHelper
  def self.default_draft
    [
        [{'ban' => nil}],
        [{'ban' => nil}],
        [{'pick' => nil}],
        [{'pick' => nil}, {'pick' => nil}],
        [{'ban' => nil}],
        [{'ban' => nil}],
        [{'pick' => nil}, {'pick' => nil}],
        [{'pick' => nil}]
    ]
  end

  def self.pick(session, pick)
    if !session[:draft]
      session[:draft] = {}
    end

    if !session[:draft][:picks]
      session[:draft][:picks] = []
    end

    return if session[:draft][:picks].include?(pick)

    session[:draft][:picks] << pick
  end

  def self.next_pick(session)
    session['draft']['index'] += 1
  end

  def self.index(session)
    session['draft']['index'] ||= 0
  end

  # def self.pick_order(session)
  #   return if !session[:draft] || !session[:draft][:first_pick]
  #
  #   # red ban
  #   # blue ban
  #   # red 1 pick
  #   # blue 2 picks
  #   # red 2 picks
  #   # blue ban
  #   # red ban
  #   # blue 2 picks
  #   # red 2 picks
  #   # blue 1 pick
  # end
end