class Movie < ActiveRecord::Base
    def with_ratings(ratings)
        if ratings.empty? then
          @displayR = Movie.all
        else
          @displayR = Movie.where(rating:ratings)
        end
        @displayR
    end
end
