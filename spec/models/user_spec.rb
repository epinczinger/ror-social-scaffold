require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Associations' do
    it 'does have association with friendships model' do
      association = User.reflect_on_association(:friendships)
      expect(association.macro).to eq(:has_many)
    end

    it 'does have association with post model' do
      association = User.reflect_on_association(:posts)
      expect(association.macro).to eq(:has_many)
    end
  end

  context 'Validations' do
    it 'must have name' do
      new_user = User.new(email: 'ert@hg.com', password: '123123')
      expect(new_user.save).to eq(false)
    end

    it 'must have email' do
      new_user = User.new(name: 'Esteban', password: '123123')
      expect(new_user.save).to eq(false)
    end

    it 'must have password' do
      new_user = User.new(name: 'Esteban', email: 'ert@hg.com')
      expect(new_user.save).to eq(false)
    end

    it 'should save having name, email and password' do
      new_user = User.new(name: 'Esteban', email: 'ert@hg.com', password: '123123')
      expect(new_user.save).to eq(true)
    end

    it 'name length has to be minor than 20 char' do
      new_user = User.new(name: 'Thisisaveryveryverylongname', email: 'ert@hg.com', password: '123123')
      expect(new_user.save).to eq(false)
    end
  end

  context 'Methods' do
    before(:each) do
      @user1 = User.create(name: 'User1', email: 'u1@g.com', password: '123123')
      @user2 = User.create(name: 'User2', email: 'u2@g.com', password: '123123')
      @user3 = User.create(name: 'User3', email: 'u3@g.com', password: '123123')
    end

    it 'return an array with users friends' do
      expect(@user1.friends.class).to eql(Array)
    end

    it 'return an array with users pending_friends' do
      expect(@user1.pending_friends.class).to eql(Array)
    end

    it 'return an array with users friend_requests' do
      expect(@user1.friend_requests.class).to eql(Array)
    end

    it 'should return two pending friends request' do
      @user1.friendships.new(friend_id: @user2.id, status: false).save
      @user1.friendships.new(friend_id: @user3.id, status: false).save
      expect(@user1.pending_friends.length).to eq(2)
    end

    it 'should return array with two friends' do
      @user1.friendships.new(friend_id: @user2.id, status: true).save
      expect(@user1.friends.length).to eq(1)
    end

    it 'should return true when users are friends' do
      @user1.friendships.new(friend_id: @user2.id, status: true).save
      expect(@user1.friend?(@user2)) == true
    end

    it 'should return true when creating two rows when users are friends ' do
      @user1.friendships.new(friend_id: @user2.id, status: false).save
      @user2.confirm_friend(@user1)
      expect(@user1.friend?(@user2) && @user2.friend?(@user1)) == true
    end
  end
end
