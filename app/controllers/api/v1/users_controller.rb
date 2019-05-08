module Api
  module V1
    class UsersController < ApplicationController
      skip_before_action :authenticate_request!, only: [:login, :create, :confirm] 
      before_action :check_user_authorized, only: [:update]
      before_action :find_user, only: [:update]

      def create
        user = User.new(user_params)
        if user.save
          token = JsonWebToken.encode(user_id: user.id)
          UserMailer.signup_confirmation(user).deliver_later
          render json: { message: 'User created successfully', token: token }, status: :created
        else
          render json: { errors: user.errors.messages }, status: :bad_request
        end
      end

      def confirm
        token = params[:token].to_s
      
        user = User.find_by(confirmation_token: token)
      
        if user.present? && user.confirmation_token_valid?
          user.mark_as_confirmed!
          render json: { message: 'User confirmed successfully' }, status: :ok
        else
          render json: { errors: { base: 'Invalid token' } }, status: :not_found
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

      def forgot
        return render json: {error: 'Email not present'} if params[:email].blank?
        user = User.find_by(email: email.downcase)
    
        if user.present? && user.confirmed_at?
          user.generate_password_token!
          UserMailer.reset_password(user).deliver_later
          render json: { message: 'ok' }, status: :ok
        else
          render json: { error: { base: 'Email address not found. Please check and try again.'}}, status: :not_found
        end
      end
    
      def reset
        token = params[:token].to_s
        return render json: {error: 'Token not present'} if params[:email].blank?
        user = User.find_by(reset_password_token: token)
    
        if user.present? && user.password_token_valid?
          if user.reset_password!(params[:password])
            render json: {message: 'ok'}, status: :ok
          else
            render json: {error: user.errors.messages}, status: :unprocessable_entity
          end
        else
          render json: {error:  { base: 'Link not valid or expired. Try generating a new link.'}}, status: :not_found
        end
      end

      def update_password
        return render json: { error: 'Password not present' }, status: :unprocessable_entity unless params[:password].present?
        if @current_user.reset_password(params[:password])
          render status: :no_content
        else
          render json: { errors: @current_user.errors.messages }, status: :unprocessable_entity
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
          render json: { errors: user.errors.messages }, status: :bad_request
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
