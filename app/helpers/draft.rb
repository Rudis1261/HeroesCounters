module DraftHelper
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
end