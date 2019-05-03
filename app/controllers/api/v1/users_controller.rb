module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request!, only: [:login, :create] 
      before_action :check_user_authorized, only: [:update]
      before_action :find_user, only: [:update]

      def create
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { message: 'User created successfully', token: token }, status: :created
        else
          render json: { errors: user.errors.messages }, status: :bad_request
        end
      end

      def login
        user = User.find_by(email: params[:user][:email].to_s.downcase)
        if user && user.authenticate(params[:user][:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { message: 'User logged in successfully', token: token }, status: :ok
        else
          render json: { errors: { base: 'Invalid username or password'} }, status: :unauthorized
        end
      end

      def show  
        user = User.where(id: user_id).left_outer_joins(:strengths, :concerns).first
        render json: serializer.new(user, include: [:strengths, :concerns]), status: :ok
      end

      def update
        if @user.update(user_params) 
          render status: :no_content
        else
          render json: { errors: user.errors.full_messages }, status: :bad_request
        end
      end

      def favorite 
        user = User.find(params[:id])
        @current_user.follow(user)
        render json: favorites, status: :ok
      end

      private

      def find_user 
        @user = User.find(user_id)
      end

      def check_user_authorized
        return invalid_authentication unless authorized?
      end

      def user_id 
        params[:id] || @current_user.id
      end

      def authorized?
        return true if params[:id].nil?
        params[:id].to_i == @current_user.id 
      end

      def serializer
        UserSerializer
      end

      def user_params
        params.require(:user).permit(:email,
                                     :password,
                                     :password_confirmation,
                                     :avatar, 
                                     :username,
                                     :education,
                                     :gender,
                                     :birth_year,
                                     strengths_attributes: [:id, :name, :selected],
                                     concerns_attributes: [:id, :name, :selected])
      end

    end
  end
end
