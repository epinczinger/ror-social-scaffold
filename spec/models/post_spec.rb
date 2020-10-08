require 'rails_helper'

RSpec.describe Post, type: :model do

    context 'Associations' do

        it 'Post does not have association with friendships model' do
            association = Post.reflect_on_association(:friendships)
            expect(association.nil?).to be true
        end
    end

    context 'Validations' do

        it 'must have content' do
            new_post = Post.new(user_id: 1)
            expect(new_post.save).to eq(false)
        end

        it 'should save succesfully' do 
            new_post = Post.new(user_id: 1, content: 'This is content').save
            expect(new_post) == true
        end
    end
    
end