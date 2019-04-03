module Api
  module V1
    class UsersController < ApplicationController
      def create
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          render json: { message: 'User created successfully', token: token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :bad_request
        end
      end

      def login
        user = User.find_by(email: params[:user][:email].to_s.downcase)
        if user && user.authenticate(params[:user][:password])
          token = JsonWebToken.encode(user_id: user.id)
          render json: { message: 'User logged in successfully', token: token }, status: :ok
        else
          render json: { error: 'Invalid username or password' }, status: :unauthorized
        end
      end

      def show       
        user = User.where(id: params[:id]).left_outer_joins(:interests).distinct
        render json: serializer.new(user, include: [:interests])
      end

      def update
        user = User.find(params[:id])

        if user.update(user_params) 
          render status: :no_content
        else
          render json: { error: user.errors.full_messages }, status: :bad_request
        end
      end

      private

      def serializer
        UserSerializer
      end

      def user_params
        params.require(:user).permit(:email,
                                     :password,
                                     :password_confirmation,
                                     :avatar, 
                                     :username,
                                     :gender,
                                     :birth_year,
                                     interests_attributes: [:name, :type])
      end

    end
  end
end
