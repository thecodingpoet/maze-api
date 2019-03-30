module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          auth_token = JsonWebToken.encode({user_id: user.id})
          render json: {message: 'User created successfully', auth_token: auth_token}, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :bad_request
        end
      end

      def login
        user = User.find_by(email: params[:user][:email].to_s.downcase)
        if user && user.authenticate(params[:user][:password])
          auth_token = JsonWebToken.encode({user_id: user.id})
          binding.pry
          render json: {message: 'User logged in successfully', auth_token: auth_token}, status: :ok
        else
          render json: {error: 'Invalid username or password'}, status: :unauthorized
        end
      end

      private

      def user_params
        params.require(:user).permit(:email, :password, :password_confirmation, :avatar, :username, :gender, :birth_year)
      end

    end
  end
end
