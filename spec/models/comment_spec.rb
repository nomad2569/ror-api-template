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
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:content) }
    it { is_expected.to validate_length_of(:content).is_at_most(1000) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:post) }
  end

  describe 'comment_limit_per_post' do
    let(:post) { create(:post) }

    context 'when post has less than 100 comments' do
      it 'allows creating a new comment' do
        99.times { create(:comment, post: post) }
        comment = build(:comment, post: post)
        expect(comment).to be_valid
      end
    end

    context 'when post already has 100 comments' do
      it 'prevents creating a new comment' do
        100.times { create(:comment, post: post) }
        comment = build(:comment, post: post)
        expect(comment).not_to be_valid
        expect(comment.errors[:base]).to include('게시물당 최대 100개의 댓글만 작성할 수 있습니다.')
      end
    end
  end

  describe 'cascade deletion' do
    let(:user) { create(:user) }
    let(:post) { create(:post) }

    it 'is deleted when associated post is deleted' do
      create(:comment, user: user, post: post)
      expect { post.destroy }.to change { Comment.count }.by(-1)
    end

    it 'is deleted when associated user is deleted' do
      create(:comment, user: user, post: post)
      expect { user.destroy }.to change { Comment.count }.by(-1)
    end
  end

  describe 'content length' do
    let(:long_content) { 'a' * 1001 }

    it 'is invalid with content longer than 1000 characters' do
      comment = build(:comment, content: long_content)
      expect(comment).not_to be_valid
      expect(comment.errors[:content]).to include('is too long (maximum is 1000 characters)')
    end
  end
end
