class Answer < ActiveRecord::Base
  # by having this 'belongs_to' in the model we can easily fetch the question
  # for a fiven answer by running:
  # ans = Answer.find(14)
  # q = anss.question
  # belongs_to assuems that the 'answers' table has a foreign_key called
  # quesiton_id (Rails convention)
  belongs_to :question
  belongs_to :user

  validates :body, presence: true

  def user_full_name
    # if the user exists, give it a full name, otherwise
    # return empty string to titleizing that would be ok
    user ? user.full_name : ""
  end

end
