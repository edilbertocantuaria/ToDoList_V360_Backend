class TagsController < ApplicationController
    include AuthorizeRequest

    def new
        @tags = Tag.new
    end

    def index
        tags = @current_user.tags
        if tags.any?
            render json: {tags: tags}, status: :ok
        else
            render json: {message: 'No tags found'}, status: :not_found
        end
    end    
    
    def show
        tag = @current_user.tags.find_by(id: params[:tagId])
        if tag
            render json: tag, status: :ok
        else
            render json: {message: 'Tag not found'}, status: :not_found
        end
    end
    
    def create
        ActiveRecord::Base.transaction do
            tag = @current_user.tags.new(tag_params)
            if tag.save!
                render json: tag, status: :ok
            else
                render json: {errors: tag.errors.full_messages}, status: :unprocessable_entity
            end
        end    
    rescue ActiveRecord::Rollback
    end
    
    def update
        tag = @current_user.tags.find_by(id: params[:tagId])
        if tag.update(tag_params)
            render json: tag, status: :ok
        else
            render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
    rescue ActiveRecord::Rollback
    end

    def destroy
        tag = @current_user.tags.find_by(id: params[:tagId])
        tag.destroy
        head :no_content
    rescue ActiveRecord::Rollback
        render json: { message: 'Tag not found' }, status: :not_found
    end     
   
    def tag_params
        params.require(:tag).permit(:tag_name)
    end   


end
