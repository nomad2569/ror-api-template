# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  content    :text
#  user_id    :bigint           not null
#  post_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_comments_on_post_id  (post_id)
#  index_comments_on_user_id  (user_id)
#
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :content, presence: true,
                      length: { maximum: 1000 }

  validate :comment_limit_per_post, on: :create

  private

  def comment_limit_per_post
    return unless post.comments.count >= 100

    errors.add(:base, '게시물당 최대 100개의 댓글만 작성할 수 있습니다.')
  end
end
