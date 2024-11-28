# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  title      :string(100)      not null
#  content    :text             not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_posts_on_created_at  (created_at)
#  index_posts_on_user_id     (user_id)
#
class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true,
                    length: { maximum: 100 }
  validates :content, presence: true

  validate :daily_post_limit, on: :create

  private

  def daily_post_limit
    return unless user.posts.where('created_at > ?', Time.current.beginning_of_day).count >= 5

    errors.add(:base, '하루에 최대 5개의 게시물만 작성할 수 있습니다.')
  end
end
