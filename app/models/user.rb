class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }

  has_many :posts
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :friendships
  has_many :inverse_friendships, class_name: 'Friendship', foreign_key: 'friend_id'

  def friends
    friends_array = friendships.map do |friendship|
      friendship.friend if friendship.status
    end + inverse_friendships.map do |friendship|
            friendship.user if friendship.status
          end
    friends_array.compact
  end

  # Users who have yet to confirme friend requests
  def pending_friends
    friendships.map { |friendship| friendship.friend unless friendship.status }.compact
  end

  # Users who have requested to be friends
  def friend_requests
    inverse_friendships.map { |friendship| friendship.user unless friendship.status }.compact
  end

  def confirm_friend(user)
    friendship = inverse_friendships.find { |fship| fship.user == user }
    friendship.status = true
    friendship.save
    Friendship.create!(friend_id: user.id, user_id: id, status: true)
  end

  def friend?(user)
    friends.include?(user)
  end

  def reject_request(user)
    friendship = inverse_friendships.find { |fship| fship.user == user }
    friendship.destroy
  end

  def friends_ids
    friends_ids = friends.map(&:id)
    friends_ids << id
    friends_ids.compact
  end
end
