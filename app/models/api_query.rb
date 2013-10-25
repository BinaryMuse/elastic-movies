class ApiQuery
  include HTTParty
  base_uri 'api.themoviedb.org'

  def top_rated(page=1)
    self.class.get("/3/movie/top_rated?page=#{page}&api_key=#{ENV['MOVIEDB_API_KEY']}")
  end

  def movie(id)
    self.class.get("/3/movie/#{id}?append_to_response=casts&api_key=#{ENV['MOVIEDB_API_KEY']}")
  end
end
