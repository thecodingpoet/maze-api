module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_writing, only: [:create]

      def create 
        comment = @writing.comments.new(comment_params)
        comment.user = @current_user

        if comment.save 
          render json: { message: 'Comment created successfully' }, status: :ok
        else 
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private 

      def find_writing 
        @writing = Writing.find(params[:writing_id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end  
end
