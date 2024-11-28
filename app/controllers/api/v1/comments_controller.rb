module API
  module V1
    class CommentsController < APIController
      include API::Concerns::ActAsAPIRequest

      before_action :authenticate_user!
      before_action :set_post
      before_action :set_comment, only: %i[update destroy]

      def index
        @comments = @post.comments
                         .includes(:user)
                         .order(created_at: :desc)
                         .page(params[:page])
      end

      def create
        @comment = @post.comments.build(comment_params)
        @comment.user = current_user

        if @comment.save
          render :create, status: :created
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @comment.user_id == current_user.id && @comment.update(comment_params)
          render :create
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @comment.user_id == current_user.id
          @comment.destroy
          head :no_content
        else
          render json: { error: '권한이 없습니다' }, status: :forbidden
        end
      end

      private

      def set_post
        @post = Post.find(params[:post_id])
      end

      def set_comment
        @comment = @post.comments.find(params[:id])
      end

      def comment_params
        params.require(:comment).permit(:content)
      end
    end
  end
end
