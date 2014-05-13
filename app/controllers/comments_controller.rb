class CommentsController < ApplicationController
  def new
    puts "making a new comment"
    @comment            = Comment.new
    @comment.body       = params[:body]
    @comment.story_id   = params[:story_id]
    @comment.username   = current_user.name 
    @comment.user_id    = current_user.uid
    @comment.comment_id = BSON::ObjectId.new.to_s
    @comment.created_at = Time.now

    @story = Story.find(params[:story_id])
    parent = @story.comments.where({:comment_id => params[:parent_id]}).first
    if parent
      @comment.parent_id  = params[:parent_id]
      @comment.depth      = parent[:depth] + 1
    end
    @story.comments.push(@comment)
    redirect_to "/stories/" + @story.id + "/show_comments"
  end
end
