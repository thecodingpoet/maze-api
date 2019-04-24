module Api
  module V1
    class WritingsController < ApplicationController
      before_action :find_writing, only: [:show]

      def index
        writings = Writing.limit(10)
        render json: serializer.new(writings), status: :ok
      end

      def create 
        writing = @current_user.writings.new(writing_params)
        if writing.save 
          render json: { message: 'Writing created successfully' }, status: :ok
        else 
          render json: { errors: writing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def show 
        render json: serializer.new(@writing, include: [:user, :comments]), status: :ok
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
