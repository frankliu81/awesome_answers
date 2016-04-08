class Question < ActiveRecord::Base

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

  private

  # same as Question.recent_three
  # def self.recent_three
  #   order("created_at DESC").limit(3)
  # end
  #

  # using scope for customize query
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
