class Movie < ActiveRecord::Base
  has_many :taggings
  has_many :genres, through: :taggings

  has_many :parts
  has_many :actors, through: :parts

  def picture
    url = super
    "https://d3gtl9l2a4fn1j.cloudfront.net/t/p/w154#{url}"
  end
end
