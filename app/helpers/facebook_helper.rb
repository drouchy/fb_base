module FacebookHelper
  def facebook_login_button(size='large')
    content_tag("fb:login-button", nil , {
      :scope => 'user_likes, friends_likes,read_stream',
      :id => "fb_login",
      :autologoutlink => 'true',
      :size => size,
      :onlogin => 'location = "/"'})
  end

  def options_from_friends(friends)
    friends.sort {|f1, f2| f1['name'] <=> f2['name'] }.map {|friend| [friend['name'], friend['id']]}
  end
end
