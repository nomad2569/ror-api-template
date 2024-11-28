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
require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:title).is_at_most(100) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'daily_post_limit' do
    let(:user) { create(:user) }

    context 'when user has less than 5 posts today' do
      it 'allows creating a new post' do
        4.times { create(:post, user: user) }
        post = build(:post, user: user)
        expect(post).to be_valid
      end
    end

    context 'when user has 5 posts today' do
      it 'prevents creating a new post' do
        5.times { create(:post, user: user) }
        post = build(:post, user: user)
        expect(post).not_to be_valid
      end
    end
  end
end
