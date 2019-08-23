class HomeController < ApplicationController
  skip_before_action :authenticate_request!, only: [:index] 
  def index
    render json: { message: "Maze Backend API"}, status: :ok
  end
end
