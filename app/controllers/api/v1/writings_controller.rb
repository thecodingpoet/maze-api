module Api
  module V1
    class WritingsController < ApplicationController
      before_action :find_writing, only: [:show, :share, :archive]

      def index
        writings = @current_user.writings.order('created_at DESC')
        render json: serializer.new(writings, include: [:user, :comments]), status: :ok
      end

      def timeline 
        writings = Writing.order('created_at DESC').limit(5)
        render json: serializer.new(writings, include: [:user, :comments]), status: :ok
      end

      def create 
        writing = @current_user.writings.new(writing_params)
        if writing.save 
          render json: { message: 'Writing created successfully' }, status: :ok
        else 
          render json: { errors: writing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def share
        @writing.errors.add(:base, "Writing is not a draft") unless @writing.draft?
        @writing.status = "shared"
        if !@writing.errors && @writing.update(writing_params)
          render status: :no_content
        else
          render json: { errors: @writing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def save 
        writing = @current_user.writings.new(writing_params)
        writing.status = "draft"
        if writing.save 
          render json: { message: 'Writing saved successfully' }, status: :ok
        else 
          render json: { errors: writing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def archive
        @writing.archived!
        render json: { message: 'Writing archived successfully' }, status: :ok
      end

      def show 
        render json: serializer.new(@writing, include: [:user, :comments]), status: :ok
      end

      def saved
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

      def find_writing 
        @writing = Writing.find(params[:id])
      end

      def writing_params
        params.require(:writing).permit(:title, :entry)
      end
    end
  end  
end
