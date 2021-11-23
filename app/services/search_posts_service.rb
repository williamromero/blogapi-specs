class SearchPostsService
  def self.search(filtered_posts, search)
    # Los cache funcionan como un objecto llave valor
    # que se guardará en memoria si no se ha buscado antes
    # { k => v }
    posts_list = Rails.cache.fetch("posts_search/#{search}", expires_in: 1.hours) do
      filtered_posts.where("title like '%#{search}%'").map(&:id)
    end

    filtered_posts.where(id: posts_list)
  end
end
