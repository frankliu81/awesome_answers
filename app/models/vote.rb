class Vote < ActiveRecord::Base
  belongs_to :question
  belongs_to :user

  # if the vote record doesn't exist, then there is no vote
  # but if you vote, it has to be present
  # NOTE: do not use presence: true for true, and false
  # in Ruby, false is falsy, and so is nil, so presence: true validation
  # will fail for false
  validates_inclusion_of :is_up, :in => [true, false]
  # prevent two votes from the same user
  validates :user_id, uniqueness: {scope: :question_id}

  # implement with scope as an alternative to class method
  scope :up_count, -> { where(is_up: true).count }
  # def self.up_count
  #   where(is_up: true).count
  # end

  def self.down_count
    where(is_up: false).count
  end

end
