module Api
  module V1
    class WritingsController < ApplicationController
      before_action :find_writing, only: [:show, :update_draft, :publish_draft, :archive]
      before_action :check_draft, only: [:update_draft, :publish_draft]

      def index
        writings = @current_user.writings.order('created_at DESC')
        render json: serializer.new(writings, include: [:user, :comments]), status: :ok
      end

      def timeline 
        writings = Writing.shared.
                           without_user_writings(@current_user).
                           without_user_supports(@current_user).
                           limit(5)
        render json: serializer.new(writings, include: [:user]), status: :ok
      end

      def create 
        writing = @current_user.writings.new(writing_params)
        if writing.save 
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
        render json: { message: 'Writing archived successfully' }, status: :ok
      end

      def show 
        render json: serializer.new(@writing, include: [:user, :comments]), status: :ok
      end

      def drafts
        writings = @current_user.writings.draft
        render json: serializer.new(writings, include: [:user, :comments]), status: :ok
      end

      def support 
        writings = Writing.joins(:comments).where(:comments => {user_id: @current_user.id})
        render json: serializer.new(writings, include: [:user, :comments]), status: :ok
      end

      private

      def serializer
        WritingSerializer
      end

      def check_draft
        return render json: { errors: { base: 'Writing is not a draft' } }, status: :bad_request unless @writing.draft?
      end

      def find_writing 
        @writing = Writing.find(params[:id])
      end

      def writing_params
        params.require(:writing).permit(:title, :entry)
      end
    end
  end  
end
