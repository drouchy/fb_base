class User
  attr_accessor :uid, :graph

  def initialize(graph, uid)
    @graph = graph
    @uid = uid
  end

  def likes
    @likes ||= graph.get_connections(@uid, 'likes')
  end

  def likes_by_category
    @likes_by_category ||= likes.sort_by {|l| l['name']}.group_by {|l| l['category']}.sort
  end

  def friends
    @friends ||= graph.get_connections(@uid, 'friends')
  end

  def rank_friend(friend_id)
    posts = graph.get_connections(friend_id, 'feed')
    [
      {
          :name => 'F2',
          :nb_comments => 3
      },
      {
          :name => 'F1',
          :nb_comments => 30
      }
    ]
  end
end
