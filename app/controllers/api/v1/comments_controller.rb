module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_writing
      before_action :find_comment, except: [:create]
      before_action :check_user_authorized, except: [:create]

      def create 
        comment = @writing.comments.new(comment_params)
        comment.user = @current_user

        if comment.save 
          render json: { message: 'Comment created successfully' }, status: :ok
        else 
          render json: { errors: comment.errors.messages }, status: :unprocessable_entity
        end
      end

      def accept 
        @comment.update_attribute(:approved, true)
        render status: :no_content
      end

      def decline
        @comment.update_attribute(:approved, false)
        render status: :no_content 
      end

      private 

      def check_user_authorized 
        return invalid_authentication unless authorized?  
      end

      def authorized?
        @writing.user.id === @current_user.id
      end

      def find_comment 
        @comment = Comment.find(params[:id])
      end

      def find_writing 
        @writing = Writing.find(params[:writing_id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end  
end
