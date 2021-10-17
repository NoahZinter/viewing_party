class MoviesFacade
  class << self
    def discover
      json = TMDBService.discover
      movie_creator(json)
    end

    def search(query = 'untitled')
      json = TMDBService.search(query)
      movie_creator(json)
    end

    def top_rated
      #Argument in top_rated method is page number, facade is populating top 40 results instead of default 20
      page_1 = TMDBService.top_rated
      page_2 = TMDBService.top_rated(2)
      movie_creator(page_1) + movie_creator(page_2)
    end

    def find(id)
      json = TMDBService.find(id)
      if json[:success] == false
        nil
      else
        MovieDetail.new(json)
      end
    end

    private

    def movie_creator(json)
      json[:results].map do |movie|
        Movie.new(movie)
      end
    end
  end
end
