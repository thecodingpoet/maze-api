class HomeController < ApplicationController
  def index
    render json: { message: "I-LU Backend API"}, status: :ok
  end
end