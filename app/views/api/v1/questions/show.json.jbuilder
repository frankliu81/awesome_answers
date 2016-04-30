# json.(@question, :id, :title, :body)
# json.answers do
  #  json.answer @question.answers, :body, :id
# end
# json.tags @question.tags, :name

# json.question @question.attributes
# the key is question and the value is everything within the do
json.question do
  json.title @question.title
  json.body @question.body
  # json.title @question.title
  # json.title @question.title
  json.answers @question.answers do |answer|
    json.body answer.body
  end
  # json.tags @question.tags do |tag|
  #   json.tag tag.name
  # end
  # the above will send the tag with the tag, the bottom will just send the name, the single value
  json.tags @question.tags.map(&:name)
end
# with JSON we are either sending an array or an object.
