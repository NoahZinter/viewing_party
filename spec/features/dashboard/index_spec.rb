require 'rails_helper'

RSpec.describe 'Dashboard Index' do
  before :each do
    User.destroy_all
    @user = User.create!(username:'Tim', email: 'tim@ex.com', password_digest: 'apples')
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    visit '/dashboard'
  end

  context 'has content' do
    it 'welcomes the user' do
      expect(page).to have_content('Welcome Tim')
    end

    it 'has link to discover movies' do
      expect(page).to have_link('Discover Movies', href: '/discover')
    end

    it 'should have a friends section' do
      expect(page).to have_content('Friends')
    end

    it 'friends section should have a search field' do
      expect(page).to have_field('email')
    end

    it 'contains a button to add a friend' do
      expect(page).to have_button('Add Friend')
    end

    it 'adds a friend' do
      User.create!(username:'Sally', email: 'sally@ex.com', password_digest: 'apples')
      fill_in :email, with: 'sally@ex.com'
      click_button('Add Friend')

      expect(current_path).to eq dashboard_path
      expect(page).to have_content('Sally added as a friend!')
    end

    it 'does not add friends who do not exist' do
      User.create!(username:'Sally', email: 'sally@ex.com', password_digest: 'apples')
      fill_in :email, with: 'bally@ex.com'
      click_button('Add Friend')

      expect(current_path).to eq dashboard_path
      expect(page).to have_content('Sorry! Friend not added.')
    end

    it 'starts with zero friends' do
      expect(page).to have_content 'You currently have no friends!'
    end

    it 'displays all added friends' do
      sally = User.create!(username:'Sally', email: 'sally@ex.com', password_digest: 'apples')
      mally = User.create!(username:'Mally', email: 'mally@ex.com', password_digest: 'apples')
      fally = User.create!(username:'Fally', email: 'fally@ex.com', password_digest: 'apples')
      @user.user_friends.create!(user: @user, friend: sally)
      @user.user_friends.create!(user: @user, friend: mally)
      @user.user_friends.create!(user: @user, friend: fally)

      visit dashboard_path

      expect(page).to have_content(sally.username)
      expect(page).to have_content(sally.email)
      expect(page).to have_content(mally.username)
      expect(page).to have_content(mally.email)
      expect(page).to have_content(fally.username)
      expect(page).to have_content(fally.email)
    end

    it 'displays formatting for added friends' do
      sally = User.create!(username:'Sally', email: 'sally@ex.com', password_digest: 'apples')
      mally = User.create!(username:'Mally', email: 'mally@ex.com', password_digest: 'apples')
      fally = User.create!(username:'Fally', email: 'fally@ex.com', password_digest: 'apples')
      @user.user_friends.create!(user: @user, friend: sally)
      @user.user_friends.create!(user: @user, friend: mally)
      @user.user_friends.create!(user: @user, friend: fally)

      visit dashboard_path

      expect(page).to have_content('Friend Username:', count: 3)
      expect(page).to have_content('Friend Email:', count: 3)
    end

    it 'should have a viewing party section' do
      expect(page).to have_content('Viewing Parties')
    end

    it 'list all view partys' do
      u1 = create(:user)
      user_vps = []
      u1_vps = []
      3.times do
        user_vps << create(:view_party, user: @user)
        u1_vps << create(:view_party, user: u1)
      end
      user_vps.each do |vp|
        ViewPartyUser.create!(view_party_id: vp.id, user_id: u1.id)
      end
      u1_vps.each do |vp|
        ViewPartyUser.create!(view_party_id: vp.id, user_id: @user.id)
      end
      visit dashboard_path
      ViewPartyUser.all.each do |vpu|
        expect(page).to have_content(vpu.user.username)
      end
      expect(find_all('p', text: "Host: #{u1.username}").size).to eq 3
      expect(find_all('p', text: @user.username).size).to eq 3
      ViewParty.all do |vp|
        expect(page).to have_content(vp.event_time.to_formatted_s(:long))
      end
    end
  end
end
