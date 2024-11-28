json.id comment.id
json.content comment.content
json.created_at comment.created_at
json.updated_at comment.updated_at

json.user do
  json.id comment.user.id
  json.email comment.user.email
  json.username comment.user.username
end
