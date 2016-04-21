class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :question

  # combination of user_id and question_id
  validates :user_id, uniqueness: {scope: :question_id}
end
