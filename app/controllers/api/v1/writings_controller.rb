module Api
  module V1
    class WritingsController < ApplicationController
      before_action :find_writing, only: [:show, :update_draft, :publish_draft, :archive]
      before_action :check_draft, only: [:update_draft, :publish_draft]
      after_action :read_comments, only: [:show]

      def index
        writings = @current_user.writings.shared_or_archived.page(params[:page])
        render json: serializer.new(writings, include: [:user]), status: :ok
      end

      def timeline 
        render json: serializer.new(timeline_writings, include: [:user]), status: :ok
      end

      def create 
        writing = @current_user.writings.new(writing_params)
        if writing.save 
          WritingMailer.first_writing_notification(writing).deliver_later if @current_user.writings.length == 1
          render json: { message: 'Writing created successfully' }, status: :ok
        else 
          render json: { errors: writing.errors.messages }, status: :unprocessable_entity
        end
      end

      def update_draft
        if @writing.update(writing_params)
          render status: :no_content
        else
          render json: { errors: @writing.errors.messages }, status: :unprocessable_entity
        end
      end

      def publish_draft
        @writing.status = "shared"
        if @writing.update(writing_params)
          render json: { message: 'Writing has been published' }, status: :ok
        else
          render json: { errors: @writing.errors.messages }, status: :unprocessable_entity
        end
      end

      def save_draft
        writing = @current_user.writings.new(writing_params)
        writing.status = "draft"
        if writing.save 
          render json: { message: 'Writing saved successfully' }, status: :ok
        else 
          render json: { errors: writing.errors.messages }, status: :unprocessable_entity
        end
      end

      def archive
        @writing.archived!
        notify_thread_participants
        render json: { message: 'Writing archived successfully' }, status: :ok
      end

      def show 
        options = {
          :include => [:user, :comments],
          :params => { show_read: user_created_writing? }
        }
        render json: serializer.new(@writing, options), status: :ok 
      end

      def drafts
        writings = @current_user.writings.draft.page(params[:page])
        render json: serializer.new(writings, include: [:user]), status: :ok
      end

      def support 
        writings = Writing.shared.
                           without_user_writings(@current_user).
                           with_user_supports(@current_user).
                           without_declined_support.
                           uniq
        
        render json: serializer.new(writings, include: [:user, :comments]), status: :ok
      end

      private

      def timeline_writings
        page = 1
        feed = get_feed_writings(page)
        while (feed.length <= 5) do
          page += 1
          writings = get_feed_writings(page)
          break if writings.empty?
          feed << writings
          feed.flatten
        end
        feed.first(5)
      end

      def get_feed_writings(page)
        Writing.shared.
                without_user_writings(@current_user).
                includes(:comments).
                order('comments_count ASC').
                paginate(page: page, per_page: 30).
                reject { |w| w.comments.pluck(:user_id).include? @current_user.id }
      end

      def serializer
        WritingSerializer
      end

      def check_draft
        return render json: { errors: { base: 'Writing is not a draft' } }, status: :bad_request unless @writing.draft?
      end

      def find_writing 
        @writing = Writing.find(params[:id])
      end

      def read_comments
        @writing.comments.unread.update_all(read: true) if user_created_writing?
      end

      def user_created_writing?
        @writing.user_id == @current_user.id 
      end

      def writing_params
        params.require(:writing).permit(:title, :entry)
      end

      def notify_thread_participants
        participants = @writing.get_thread_participants.reject { |user| user.id == @current_user.id }
        participants.each { |user| WritingMailer.thread_closure_notification(@writing, user).deliver_later }
      end
    end
  end  
end
