class Comment
  include Mongoid::Document

  field :body,   type: String
  field :depth,  type: Integer, default: 0

  # Note that we are intentionally storing the parent_id
  # as a String and not an ObjectId
  field :parent_id,  type: String
  field :story_id,   type: BSON::ObjectId
  field :user_id,    type: BSON::ObjectId
  field :username,   type: String
  field :created_at, type: Time
  field :comment_id, type: String

  # Relationships
  embedded_in :story

  # Callbacks
  after_create :increment_story_comment_count

  # Return an array of threaded comments, sorted by date (oldest first)
  def self.threaded(story)
    story = Story.find(story.id)
    list_of_comments = []
    story.comments.where({ :depth => 0 }).order_by({ :created_at => -1 }).each do |root|
      list_of_comments += gather_children(root, story)
    end
    list_of_comments
  end

  # recursively assemble a threaded list of children
  def self.gather_children(comment, story)
    list_of_children = [comment]
    children = story.comments.where({ :parent_id => comment[:comment_id] })
    children.sort! { |a,b| a[:created_at] <=> b[:created_at] }
    children.each do |child|
      list_of_children += gather_children(child, story)
    end
    list_of_children
  end

  private

  def increment_story_comment_count
    Story.where(:_id => self.story_id).inc(:comment_count => 1)
  end
end
