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
    it 'finds a movie' do
      VCR.use_cassette('tmdb_service_find', :record => :new_episodes) do
        body = TMDBService.find(238)

        expect(body[:runtime]).is_a? Integer
        expect(body[:overview]).is_a? String
        expect(body[:genres]).is_a? Array
        expect(body[:credits]).is_a? Hash
        expect(body[:reviews]).is_a? Hash
      end
    end
  end
end
