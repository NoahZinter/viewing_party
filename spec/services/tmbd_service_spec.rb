require 'rails_helper'

RSpec.describe TMDBService do
  describe '.discover' do
    it 'returns JSON hash of 20 movies' do
      discover_response = TMDBService.discover

      expect(discover_response).is_a? Hash
      expect(discover_response).to have_key(:page)
      expect(discover_response[:page]).to eq 1
      expect(discover_response).to have_key(:results)
      expect(discover_response[:results]).is_a? Array
      expect(discover_response[:results].count).to eq 20

      discover_response[:results].each do |movie|
        expect(movie).is_a? Hash
        expect(movie).to have_key(:adult)
        expect(movie[:adult]).to eq false
        expect(movie).to have_key(:backdrop_path)
        expect(movie[:backdrop_path]).is_a? String
        expect(movie).to have_key(:genre_ids)
        expect(movie[:genre_ids]).is_a? Array
          movie[:genre_ids].each do |gen_id|
            expect(gen_id).is_a? Integer
          end
        expect(movie).to have_key(:id)
        expect(movie[:id]).is_a? Integer
        expect(movie).to have_key(:original_language)
        expect(movie[:original_language]).is_a? String
        expect(movie).to have_key(:overview)
        expect(movie[:overview]).is_a? String
        expect(movie).to have_key(:popularity)
        expect(movie[:popularity]).is_a? Float
        expect(movie).to have_key(:poster_path)
        expect(movie[:poster_path]).is_a? String
        expect(movie).to have_key(:release_date)
        expect(movie[:release_date]).is_a? String
        expect(movie[:release_date].to_date).is_a? Date
        expect(movie).to have_key(:title)
        expect(movie[:title]).is_a? String
        expect(movie).to have_key(:video)
        expect(movie[:video]).to eq(true).or eq(false)
        expect(movie).to have_key(:vote_average)
        expect(movie[:vote_average]).to be_a(Integer).or be_a(Float)
        expect(movie).to have_key(:vote_count)
        expect(movie[:vote_count]).is_a? Integer
      end
    end
  end

  describe '.search' do
    it 'returns JSON hash of 20 movies with full query' do
      search_response = TMDBService.search('fast')

      expect(search_response).is_a? Hash
      expect(search_response).to have_key(:page)
      expect(search_response[:page]).to eq 1
      expect(search_response).to have_key(:results)
      expect(search_response[:results]).is_a? Array
      expect(search_response[:results].count).to eq 20

      search_response[:results].each do |movie|
        expect(movie).is_a? Hash
        expect(movie).to have_key(:adult)
        expect(movie[:adult]).to eq false
        expect(movie).to have_key(:backdrop_path)
        expect(movie[:backdrop_path]).is_a? String
        expect(movie).to have_key(:genre_ids)
        expect(movie[:genre_ids]).is_a? Array
          movie[:genre_ids].each do |gen_id|
            expect(gen_id).is_a? Integer
          end
        expect(movie).to have_key(:id)
        expect(movie[:id]).is_a? Integer
        expect(movie).to have_key(:original_language)
        expect(movie[:original_language]).is_a? String
        expect(movie).to have_key(:overview)
        expect(movie[:overview]).is_a? String
        expect(movie).to have_key(:popularity)
        expect(movie[:popularity]).is_a? Float
        expect(movie).to have_key(:poster_path)
        expect(movie[:poster_path]).is_a? String
        expect(movie).to have_key(:release_date)
        expect(movie[:release_date]).is_a? String
        expect(movie[:release_date].to_date).is_a? Date
        expect(movie).to have_key(:title)
        expect(movie[:title]).is_a? String
        expect(movie).to have_key(:video)
        expect(movie[:video]).to eq(true).or eq(false)
        expect(movie).to have_key(:vote_average)
        expect(movie[:vote_average]).to be_a(Integer).or be_a(Float)
        expect(movie).to have_key(:vote_count)
        expect(movie[:vote_count]).is_a? Integer
      end
    end

    it 'does not search with an empty query param' do
      search_response = TMDBService.search('')

      expect(search_response).is_a? Hash
      expect(search_response[:errors]).is_a? Array
      expect(search_response[:errors].length).to eq 1
      expect(search_response[:errors][0]).to eq 'query must be provided'
    end
  end

  describe '.top_rated' do
    it 'retrieves top rated' do
      VCR.use_cassette('tmdb_service_top_rated', :record => :new_episodes) do
        body = TMDBService.top_rated(1)
        body_2 = TMDBService.top_rated(2)
        top_20 = body[:results]
        next_20 = body[:results]

        expect(body).is_a? Hash
        expect(top_20).is_a? Array
        expect(top_20.length).to eq 20
        expect(top_20.first[:genre_ids]).is_a? Array
        expect(top_20.first[:title]).is_a? String
        expect(next_20).is_a? Array
        expect(next_20.length).to eq 20
        expect(next_20.first[:genre_ids]).is_a? Array
        expect(next_20.first[:title]).is_a? String
      end
    end
  end

  describe 'find' do
    before(:all) do
      @found_movie = TMDBService.find(238)
    end

    it 'returns movie with matching id and relevant details' do
      expect(@found_movie[:id]).to eq 238
      expect(@found_movie[:runtime]).is_a? Integer
      expect(@found_movie[:overview]).is_a? String
      expect(@found_movie[:genres]).is_a? Array
      expect(@found_movie[:credits]).is_a? Hash
      expect(@found_movie[:reviews]).is_a? Hash
    end

    it 'returns all movie details' do
      expect(@found_movie).is_a? Hash
      expect(@found_movie).to have_key(:adult)
      expect(@found_movie[:adult]).to eq false
      expect(@found_movie).to have_key(:backdrop_path)
      expect(@found_movie[:backdrop_path]).is_a? String
      expect(@found_movie).to have_key(:belongs_to_collection)
      expect(@found_movie[:belongs_to_collection]).is_a? Hash
      expect(@found_movie[:belongs_to_collection]).to have_key(:id)
      expect(@found_movie[:belongs_to_collection][:id]).to eq 230
      expect(@found_movie[:belongs_to_collection]).to have_key(:name)
      expect(@found_movie[:belongs_to_collection][:name]).to eq 'The Godfather Collection'
      expect(@found_movie[:belongs_to_collection]).to have_key(:poster_path)
      expect(@found_movie[:belongs_to_collection][:poster_path]).is_a? String
      expect(@found_movie[:belongs_to_collection]).to have_key(:backdrop_path)
      expect(@found_movie[:belongs_to_collection][:backdrop_path]).is_a? String
      expect(@found_movie).to have_key(:budget)
      expect(@found_movie[:budget]).to eq 6000000
      expect(@found_movie).to have_key(:genres)
      expect(@found_movie[:genres]).is_a? Array
        @found_movie[:genres].each do |genre|
          expect(genre).is_a? Hash
          expect(genre).to have_key(:id)
          expect(genre[:id]).is_a? Integer
          expect(genre).to have_key(:name)
          expect(genre[:name]).is_a? String
        end
      expect(@found_movie).to have_key(:homepage)
      expect(@found_movie[:homepage]).is_a? String
      expect(@found_movie).to have_key(:id)
      expect(@found_movie[:id]).to eq 238
      expect(@found_movie).to have_key(:imdb_id)
      expect(@found_movie[:imdb_id]).to eq 'tt0068646'
      expect(@found_movie).to have_key(:original_language)
      expect(@found_movie[:original_language]).to eq 'en'
      expect(@found_movie).to have_key(:original_title)
      expect(@found_movie[:original_title]).to eq 'The Godfather'
      expect(@found_movie).to have_key(:overview)
      expect(@found_movie[:overview]).is_a? String
      expect(@found_movie).to have_key(:popularity)
      expect(@found_movie[:popularity]).is_a? Float
      expect(@found_movie).to have_key(:poster_path)
      expect(@found_movie[:poster_path]).is_a? String
      expect(@found_movie).to have_key(:production_companies)
      expect(@found_movie[:production_companies]).is_a? Array
      expect(@found_movie).to have_key(:release_date)
      expect(@found_movie[:release_date]).to eq '1972-03-14'
      expect(@found_movie).to have_key(:revenue)
      expect(@found_movie[:revenue]).is_a? Integer
      expect(@found_movie).to have_key(:runtime)
      expect(@found_movie[:runtime]).to eq 175
      expect(@found_movie).to have_key(:spoken_languages)
      expect(@found_movie[:spoken_languages]).is_a? Array
      expect(@found_movie).to have_key(:status)
      expect(@found_movie[:status]).to eq 'Released'
      expect(@found_movie).to have_key(:tagline)
      expect(@found_movie[:tagline]).to eq "An offer you can't refuse."
      expect(@found_movie).to have_key(:title)
      expect(@found_movie[:title]).to eq 'The Godfather'
      expect(@found_movie).to have_key(:video)
      expect(@found_movie[:video]).to eq(true).or eq(false)
      expect(@found_movie).to have_key(:vote_average)
      expect(@found_movie[:vote_average]).to  be_a(Integer).or be_a(Float)
      expect(@found_movie).to have_key(:vote_count)
      expect(@found_movie[:vote_count]).is_a? Integer
      expect(@found_movie).to have_key(:reviews)
      expect(@found_movie[:reviews]).is_a? Hash
    end

    it 'does not search without id' do
      expect{TMDBService.find()}.to raise_error(ArgumentError)
    end
  end
end
