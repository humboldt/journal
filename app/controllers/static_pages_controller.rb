class StaticPagesController < ApplicationController
  def home
    @entry = current_user.entries if logged_in?
  end
end
