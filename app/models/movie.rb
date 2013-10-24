class Movie < ActiveRecord::Base
  has_many :taggings
  has_many :genres, through: :taggings

  has_many :parts
  has_many :actors, through: :parts

  def picture
    url = super
    "https://d3gtl9l2a4fn1j.cloudfront.net/t/p/w154#{url}"
  end

  def self.elastic_mapping
    {
      description: { type: 'string', analyzer: 'snowball' },
      title: { type: 'string', boost: 5.0, analyzer: 'simple' },
      release_date: { type: 'date' },
      budget: { type: 'integer' },
      genres: { type: 'string', analyzer: 'keyword' }
    }
  end

  def as_elastic_json
    as_json.merge({
      genres: genres.map(&:name),
      genre_id_and_name: genres.map do |genre|
        { id: genre.id, name: genre.name }
      end,
      actors: actors.map(&:name),
      characters: parts.map(&:character)
    })
  end
end
