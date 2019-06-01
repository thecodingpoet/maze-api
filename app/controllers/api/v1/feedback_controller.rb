module Api
  module V1
    class FeedbackController < ApplicationController
      def index
        feedback = Feedback.page(params[:page])
        render json: serializer.new(feedback, include: [:user]), status: :ok
      end

      def create 
        feedback = @current_user.feedback.new(feedback_params)
        if feedback.save 
          render json: { message: 'Feedback created successfully' }, status: :ok
        else 
          render json: { errors: feedback.errors.messages }, status: :unprocessable_entity
        end
      end 

      private 

      def serializer
        FeedbackSerializer
      end
      
      def feedback_params 
        params.require(:feedback).permit(:message)
      end
    end
  end 
end
