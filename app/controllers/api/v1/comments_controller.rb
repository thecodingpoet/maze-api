module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_writing
      before_action :check_thread_active
      before_action :find_comment, except: [:create]
      before_action :check_user_authored_writing, only: [:accept, :decline]
      before_action :check_user_authored_comment, only: [:update]
      before_action :check_pending_support, only: [:create]

      def create 
        comment = @writing.comments.new(comment_params)
        comment.user = @current_user  
        comment.approved = comment_approved  
        comment.read = true if user_created_writing?    
        if comment.save 
          CommentMailer.new_support_notification(@writing).deliver_later unless user_created_writing?
          render json: { message: 'Comment created successfully' }, status: :ok
        else 
          render json: { errors: comment.errors.messages }, status: :unprocessable_entity
        end
      end

      def accept 
        @writing.comments.where(user_id: @comment.user_id).update_all(approved: true)
        CommentMailer.accepted_comment_notification(@comment).deliver_later
        notify_thread_participants
        render status: :no_content
      end

      def decline
        @writing.comments.where(user_id: @comment.user_id).update_all(approved: false)
        render status: :no_content 
      end

      def update 
        if @comment.update(comment_params)
          render json: { message: 'Comment created successfully' }, status: :ok
        else 
          render json: { errors: @comment.errors.messages }, status: :unprocessable_entity
        end
      end

      private 

      def check_user_authored_writing
        return invalid_authentication unless user_created_writing?
      end

      def check_user_authored_comment
        return invalid_authentication unless @comment.user_id == @current_user.id
      end

      def check_thread_active
        return render json: { errors: { base: 'Thread is closed' } }, status: :bad_request if @writing.archived?
      end

      def check_pending_support
        return render json: { errors: { base: 'Cannot add another support until first support is approved' } } unless writers_first_support.nil? || writers_first_support.try(:approved)
      end

      def comment_approved
        return true if user_created_writing?
        writers_first_support.try(:approved)
      end

      def user_created_writing?
        @writing.user_id == @current_user.id 
      end

      def writers_first_support
        @writing.comments.where(user_id: @current_user.id).first
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

      def notify_thread_participants
        participants = @writing.get_thread_participants.reject { |user| user.id == @current_user.id || user.id == @comment.user_id }
        participants.each { |user| CommentMailer.new_comment_notification(@writing, user).deliver_later }
      end
    end
  end  
end
