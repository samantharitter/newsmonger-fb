class Story
  include Mongoid::Document

  field :title,     type: String
  field :url,       type: String
  field :voters,    type: Array,   default: []
  field :votes,     type: Integer, default: 0
  field :relevance, type: Integer, default: 0

  # Timestamp
  field :created_at, type: Time

  # Cached values
  field :comment_count, type: Integer, default: 0
  field :username,      type: String

  # We'll use ObjectIds below, to match the _id field
  # from the parent User document.
  field :user_id, type: BSON::ObjectId

  # Relationship
  belongs_to :user
  embeds_many :comments
  
  # Validations
  url_regex = /(^$)|(^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(([0-9]{1,5})?\/.*)?$)/ix
  validates_presence_of :title, :url, :user_id
  validates_format_of :url, :with => url_regex

  # Index on the 'voters' field
  index({ voters: 1 })

  # Upvote a story by story_id
  def self.upvote(story_id, user_id)
    Story.where({ :_id => story_id, :voters => { '$ne' => user_id }}).update({ '$inc' => { :votes => 1 }, '$push' => { 'voters' => user_id }})
  end

  # Upvote this specific story
  def upvote(user)
    unless self.voters.any? {|id| id.to_s == user.uid.to_s}
      self.voters << user.uid
      self.votes += 1
      self.relevance = calculate_relevance unless new_record?
      self.save
    end
  end

  private

  # Relevance is based on newness and popularity.
  # Stories are displayed in order of relevance.
  def calculate_relevance
    return self.votes if self.created_at > 8.hours.ago.utc
  end
end
