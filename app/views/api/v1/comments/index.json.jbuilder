json.comments @comments do |comment|
  json.partial! 'comment', comment: comment
end

json.meta do
  json.current_page @comments.current_page
  json.total_pages @comments.total_pages
  json.total_count @comments.total_count
end
