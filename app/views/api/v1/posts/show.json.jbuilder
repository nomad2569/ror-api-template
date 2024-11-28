json.post do
  json.id @post.id
  json.title @post.title
  json.content @post.content
  json.created_at @post.created_at
  json.updated_at @post.updated_at

  json.user do
    json.id @post.user.id
    json.email @post.user.email
    json.username @post.user.username
  end

  json.comments @post.comments.includes(:user).order(created_at: :desc) do |comment|
    json.partial! 'api/v1/comments/comment', comment: comment
  end
end
