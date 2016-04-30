class QuestionSerializer < ActiveModel::Serializer
  # customize attributes to send as json
  attributes :id, :cap_title, :creation_date, :body
  # :created_at, :updated_at,
  # assocations
  has_many :answers

  def cap_title
    puts "<<<<<<<<< cap_title called"
    object.title.titleize
  end

  def creation_date
    object.created_at.strftime("%Y-%b-%d")
  end
end
