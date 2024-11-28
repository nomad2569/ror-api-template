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
FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence[0...100] }
    content { Faker::Lorem.paragraph }
    association :user
  end
end
