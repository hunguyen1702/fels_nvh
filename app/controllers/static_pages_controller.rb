class StaticPagesController < ApplicationController
  def home
    render "feed" if logged_in?
  end
end
