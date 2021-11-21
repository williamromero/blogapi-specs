class SearchPostsService
  def self.search(filtered_posts, search)
    # pp 'voy por aquí'
    filtered_posts.where("title like '%#{search}%'")
  end
end
