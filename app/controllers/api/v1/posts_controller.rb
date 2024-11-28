module API
  module V1
    class PostsController < APIController
      include API::Concerns::ActAsAPIRequest

      before_action :authenticate_user!
      before_action :set_post, only: %i[show update destroy]

      def index
        @posts = Post.includes(:user)
                     .order(created_at: :desc)
                     .page(params[:page])
      end

      def show; end

      def create
        @post = current_user.posts.build(post_params)

        if @post.save
          render :create, status: :created
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @post.user_id == current_user.id && @post.update(post_params)
          render :create
        else
          render json: { errors: @post.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @post.user_id == current_user.id
          @post.destroy
          head :no_content
        else
          render json: { error: '권한이 없습니다' }, status: :forbidden
        end
      end

      private

      def set_post
        @post = Post.find(params[:id])
      end

      def post_params
        params.require(:post).permit(:title, :content)
      end
    end
  end
end
