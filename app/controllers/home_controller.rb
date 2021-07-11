class HomeController < ApplicationController
  def index
    return json: {status: 'success'}
  end
end
