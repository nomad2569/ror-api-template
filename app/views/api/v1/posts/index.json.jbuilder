json.posts @posts do |post|
  json.id post.id
  json.title post.title
  json.content post.content
  json.created_at post.created_at
  json.updated_at post.updated_at

  json.user do
    json.id post.user.id
    json.email post.user.email
    json.username post.user.username
  end

  json.comments_count post.comments.count
end

json.meta do
  json.current_page @posts.current_page
  json.total_pages @posts.total_pages
  json.total_count @posts.total_count
end
