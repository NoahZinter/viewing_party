class MoviesController < ApplicationController
  def discover
    # use popular endpoint only 4
    # response = Faraday.get 'https://api.themoviedb.org/3/movie/588228?api_key=27a7c24d7fe8773fe89ef2006a4a2331'
    @image_base_url = 'https://image.tmdb.org/t/p/original'
    @movie = {
      id: 1,
      poster_path: '/qIicLxr7B7gIt5hxZxo423BJLlK.jpg',
      vote_average: 8.2,
      title: 'F9'
    }
  end

  def movies
    # only 40
    @image_base_url = 'https://image.tmdb.org/t/p/original'
    @movie = {
      id: 1,
      poster_path: '/qIicLxr7B7gIt5hxZxo423BJLlK.jpg',
      vote_average: 8.2,
      title: 'F9',
      runtime: 138
    }
  end

  def search; end

  def show
    # only 40
    @image_base_url = 'https://image.tmdb.org/t/p/original'
    @movie = {
      id: 1,
      poster_path: '/qIicLxr7B7gIt5hxZxo423BJLlK.jpg',
      vote_average: 8.2,
      title: 'F9',
      runtime: 138,
      overview: 'The world is stunned when a group of time travelers arrive from the year 2051 to deliver an urgent message: Thirty years in the future, mankind is losing a global war against a deadly alien species. The only hope for survival is for soldiers and civilians from the present to be transported to the future and join the fight. Among those recruited is high school teacher and family man Dan Forester. Determined to save the world for his young daughter, Dan teams up with a brilliant scientist and his estranged father in a desperate quest to rewrite the fate of the planet.'
    }
  end
end