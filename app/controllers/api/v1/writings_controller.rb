module Api
  module V1
    class WritingsController < ApplicationController
      def create 
        writing = @current_user.writings.new(writing_params)
        if writing.save 
          render json: { message: 'Writing created successfully' }, status: :ok
        else 
          render json: { errors: writing.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private 

      def writing_params
        params.require(:writing).permit(:title, :entry)
      end
    end
  end  
end
