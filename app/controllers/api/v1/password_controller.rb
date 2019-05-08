module Api
  module V1
    class PasswordController < ApplicationController
      skip_before_action :authenticate_request!, only: [:forgot, :reset, :update] 

      def forgot
        return render json: {error: 'Email not present'} if params[:email].blank?
        user = User.find_by(email: params[:email].downcase)

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
        return render json: {error: 'Token not present'} if params[:token].blank?
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

      def update
        return render json: { error: 'Password not present' }, status: :unprocessable_entity unless params[:password].present?
        if @current_user.reset_password(params[:password])
          render status: :no_content
        else
          render json: { errors: @current_user.errors.messages }, status: :unprocessable_entity
        end
      end
    end
  end
end