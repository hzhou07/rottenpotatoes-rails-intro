class Movie < ActiveRecord::Base
    def self.with_ratings(ratings)
        if ratings.empty? then
          @displayR = Movie.all
        else
          @displayR = Movie.where(rating:ratings)
        end
        @displayR
    end
    def self.all_ratings
        Movie.uniq.pluck(:rating)
    end
end
