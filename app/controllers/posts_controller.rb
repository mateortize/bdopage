class PostsController < ApplicationController
  before_filter :load_post, only: [:show, :comment]
  
  def index
    @posts = current_author.posts.order("created_at").page(params[:page]).per(5)
  end

  def show
  end

  def comment
    @comment = @post.comments.create(comment_params)
    @comment.commenter = current_account
    @comment.save

    redirect_to post_path(@post)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_post
    @post = current_author.posts.find(params[:id])
  end
  
end
