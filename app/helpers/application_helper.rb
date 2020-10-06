module ApplicationHelper
  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def invite_or_pending_btn(obj)
        return unless current_user.id != obj.id

        return if current_user.friend?(obj)
        out = ''
        if current_user.pending_friends.include?(obj)
                 out << link_to('pending invite', '#')
        elsif current_user.friend_requests.include?(obj)
         out << link_to('Accept', invite_path(user_id: obj.id), method: :put)
            out << link_to('Reject', reject_path(user_id: obj.id), method: :delete)
        else
           out << link_to('Invite', invite_path(user_id: obj.id), method: :post)    
   end
  out.html_safe
  end

end
