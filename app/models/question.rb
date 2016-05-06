class Question < ActiveRecord::Base

  # when using 'has_many' you must put a symbol for the associate record in
  # plural format# you also should provide the :dependent option which can be
  # either:
  # :destroy: which deletes all the associated answers when the question is deleted
  # :nullify: which makes 'quesiton_id' NULL for all associated answers
  has_many :answers, dependent: :destroy
  belongs_to :category
  belongs_to :user


  has_many :likes, dependent: :destroy
  #has_many :users,  through: :like
  # to avoid confusing
  has_many :liking_users, through: :likes, source: :user

  has_many :votes, dependent: :destroy
  has_many :voting_users, through: :votes, source: :user

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # validates_presence_of :title # deprecatead, likely removed in rails 5

  # full syntax
  # validates(:title, {presence: true, uniqueness: {message: "must be unique!"}})

  # validates :title, presence: true, uniqueness: true
  validates :title, presence: true, uniqueness: {message: "must be unique!"}
  validates :body, length: {minimum: 5}
  validates :view_count, numericality: {greater_than_or_equal_to: 0}

  # VALID_EMAIL_REGEX = /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  # validates :email, format: VALID_EMAIL_REGEX

  # this validates that the combination of title and body must be unique
  # it means that title by itself doesn't have to be unique and body by
  # itself doesn't have to be unique but the combination of the two must
  # be unique

  # combination must be unique
  # validate ;title, uniqueness: {scope: [:body, :view_count]}
  validates :title, uniqueness: {scope: :body}

  # :no_monkey custom validator, NOTE: 'validate' instead of 'validates'
  validate :no_monkey

  # this will call the 'set_defaults' method right after the initialize phase
  after_initialize :set_defaults

  before_validation :titleize_title

  # extend will add it as class methods
  extend FriendlyId
  #friendly_id :title, use: :slugged
  # allow for history of slug on update
  friendly_id :title, use: :history

  def user_full_name
    # if the user exists, give it a full name, otherwise
    # return empty string to titleizing that would be ok
    user ? user.full_name : ""
  end

  def like_for(user)
    # we are in a given question, we want to get the like object for a given user
    # we are assuming only one like, if you do where there will be multiple
    # find_by does a limit 1.  we added the uniqueness validation for like
    # q.like_for(user)
    # how do we get list of like for a quesitons
    # q.likes, all the likes for taht question, filter for the user_id
    # q.likes.find_by_user_id u
    # likes is a local method
    # if user to make sure you are not passed in nil to the
    likes.find_by_user_id user if user
  end

  def vote_for(user)
    votes.find_by_user_id user if user
  end

  def vote_value
    #votes.where(is_up: true).count - votes.where(is_up: false), count
    votes.up_count - votes.down_count
  end

  def category_name
    category.name if category
  end

  # don't use this when you have friendly_id
  #def to_param
  #  "#{id}-#{title}".parameterize
  #end


private

  # same as Question.recent_three
  # def self.recent_three
  #   order("created_at DESC").limit(3)
  # end
  #

  # using scope for customize query
  # syntactic sugar for class method
  # http://apidock.com/rails/ActiveRecord/NamedScope/ClassMethods/scope
  scope :recent_three, lambda { order("created_at DESC").limit(3)}

  # customize query
  # def self.recent_three
  #   order("created_at DESC")}.limit(3)
  # end

  # def self.recent_three
  #   order("created_at DESC")}.limit(3)
  # end

  def self.search(search_term)
    #where(["title ILIKE?", "#{string}"])
    # my solution of searching in the title or body for a string contained within
    # feature in rails use prepare statement, prepare by default will
    # sanitize the escape characters, before passing into SQL
    where(["title ILIKE? OR body ILIKE?", "%#{search_term}%", "%#{search_term}%"])

    # alternative with symbol
    #where(["title ILIKE :term OR body ILIKE :term", {term: "%#{search_term}%"} ])

    # greg's solution open to SQL injection
    # where("title ILIKE '%#{search_term}%' OR body ILIKE '%#{search_term%}'")

  end


  def titleize_title
    # self in this context references the object
    self.title = title.titleize
  end


  def set_defaults

    # conditional assignment operator
    # a = 10
    # a ||= 1
    # >a = 10
    # b = nil
    # b ||= 1
    # >b = 1
    self.view_count ||= 0

    # alternative
    #self.view_count = 0 unless self.view_count

    # note: don't do this. if you do this, you will be defining new local variable
    # view_count = 0
  end

  def no_monkey
    if title.present? && title.downcase.include?("monkey")
      # add to error hash
      errors.add(:title, "No monkeys!")
    end
  end


end
