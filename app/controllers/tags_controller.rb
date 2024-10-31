class TagsController < ApplicationController
    include AuthorizeRequest

    def new
      @tags = Tag.new
    end

    def index
      tags = @current_user.tags

      formatted_tags = format_tags(tags)

      render json: { tags: formatted_tags }, status: :ok
    end

    def show
      tag = @current_user.tags.find_by(id: params[:tagId])

      if tag
        render json: format_tag(tag), status: :ok
      else
        render json: { message: "Tag not found" }, status: :not_found
      end
    end

    def create
      ActiveRecord::Base.transaction do
        tag = @current_user.tags.new(tag_params)

        if tag.save!
          render json: format_tag(tag), status: :created
        else
          render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::Rollback
    end

    def update
      tag = @current_user.tags.find_by(id: params[:tagId])

      unless tag
        render json: { error: "Tag not found" }, status: :not_found
        return
      end

      if tag.update(tag_params)
        render json: format_tag(tag), status: :ok
      else
        render json: { errors: tag.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def destroy
      tag = @current_user.tags.find_by(id: params[:tagId])

      unless tag
        render json: { error: "Tag not found" }, status: :not_found
        return
      end

      tag.destroy
      head :no_content
    end

    def format_tags(tags)
      tags.map { |tag| format_tag(tag) }
    end

    def format_tag(tag)
      {
        idTag: tag.id,
        tagName: tag.tag_name,
        createdAt: tag.created_at,
        updatedAt: tag.updated_at
      }
    end

    def tag_params
      params.require(:tag).permit(:tag_name)
    end
end
