class StoriesController < ApplicationController

  def new
    @story = Story.new
  end

  def index
    @page    = (params[:page] || 1).to_i
    @stories = Story.all().order_by(:relevance => -1).skip((@page - 1) * 20).limit(20)
  end

  def create
    @story            = Story.new
    @story.title      = params[:title]
    @story.url        = params[:url]
    @story.user_id    = current_user.uid
    @story.username   = current_user.name
    @story.created_at = Time.now 
    if @story.save!
      @story.upvote(current_user)
      redirect_to :action => :index
    else
      redirect_to :action => :error
    end
  end

  def upvote_story
    story_id = BSON::ObjectId.from_string(params[:id])
    Story.upvote(story_id, current_user.id)
    redirect_to :action => :index
  end

  def show_comments
    @story = Story.find(params[:id])
    @comments = Comment.threaded(@story)
  end
end
