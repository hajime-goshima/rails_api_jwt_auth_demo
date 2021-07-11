class HomeController < ApplicationController
  def index
    render json: {status: 'success'}
  end
end
