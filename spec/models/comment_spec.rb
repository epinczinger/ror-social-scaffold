require 'rails_helper'

RSpec.describe Comment, type: :model do
  context 'Validations' do
    it 'must have content' do
      new_coment = Comment.new(user_id: 1, post_id: 1)
      expect(new_coment.save).to eq(false)
    end

    it 'should save succesfully' do
      new_comment = Comment.new(user_id: 1, post_id: 1, content: 'This is content').save
      expect(new_comment) == true
    end
  end
end
