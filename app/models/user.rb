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
    wall = graph.get_connections(friend_id, 'feed', {:limit => 100} )

    comments_entries = wall.map { |entry| entry['comments']}

    comments_per_entry = comments_entries.map { |comments| extract_authors_in_comments(comments) if comments['data'] }.compact

    comments_per_entry.inject({}){|sum, current| merge_two_results(sum,current)}
  end

  private

    def extract_authors_in_comments(comments)
      extracted = comments['data'].map { |comment| comment['from']['name'] }
      compute_comments_per_author(extracted)
    end

    def compute_comments_per_author(comments)
      group = comments.group_by{|author| author}
      group.merge(group) {|author, comments| comments.size }
    end

    def merge_two_results(result_1, result_2)
      result_1.merge(result_2) {|key, comments1, comments2| comments1 + comments2 }
    end
end
