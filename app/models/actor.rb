class Actor < ActiveRecord::Base
  has_many :parts
  has_many :movies, through: :parts

  def picture
    url = super
    if url.present?
      "https://d3gtl9l2a4fn1j.cloudfront.net/t/p/w185#{url}"
    else
      "http://moviekue.herokuapp.com/img/anon.png"
    end
  end
end
