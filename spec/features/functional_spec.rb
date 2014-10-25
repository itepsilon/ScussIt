require 'spec_helper'
require 'rails_helper'

describe ChannelController do
  describe "the signin process", :type => :feature do
    before :each do
      u = User.new(:email => 'q@q.q', :password => 'password', password_confirmation: 'password', username: 'qqq')
      u.skip_confirmation!
      u.save!
    end

    it "signs me in" do
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => 'q@q.q'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Log in'
      expect(page).to have_content 'q@q.q'
    end
  end

  describe "user routes", :type => :feature do
    before :each do
      u = User.new(:email => 'q@q.q', :password => 'password', password_confirmation: 'password', username: 'qqq')
      u.skip_confirmation!
      u.save!
      visit '/users/sign_in'
      within("#new_user") do
        fill_in 'Email', :with => 'q@q.q'
        fill_in 'Password', :with => 'password'
      end
      click_button 'Log in'
    end

  it "goes to a chatroom" do
    c = Channel.create!(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    visit(channel_room_path(c))
    expect(page).to have_content 'Seinfeld'
  end

  it "posts a message in the chat" do
    c = Channel.create!(:name => "Seinfeld", :image_url => "google.com", :network => "NBC", :api_id => 35)
    visit(channel_room_path(c))
    fill_in 'message_input', with: 'Scuss'
    click_button 'send_button'
    expect(page).to have_content 'Scuss'
  end


  it "tries to log out" do
    visit('/users/sign_out')
    expect(page).to have_content 'Login'
  end

  it "tries to change its information, then logs out" do
    visit('/users/edit')
    fill_in 'user[email]', with: "jackrlong@yahoo.com"
    fill_in 'user[current_password]', with: "password"
    click_button "Update"
    expect(page).to have_content 'jackrlong@yahoo.com'
    visit('/users/sign_out')
    expect(page).to have_content 'Login'
  end

  it "tries to change its information, then then login with new information" do
    visit('/users/edit')
    fill_in 'user[email]', with: "jackrlong@yahoo.com"
    fill_in 'user[current_password]', with: "password"
    click_button "Update"
    expect(page).to have_content 'jackrlong@yahoo.com'
    visit('/users/sign_out')
    expect(page).to have_content 'Login'
    visit '/users/sign_in'
    within("#new_user") do
      fill_in 'Email', :with => 'jackrlong@yahoo.com'
      fill_in 'Password', :with => 'password'
    end
    click_button 'Log in'
    expect(page).to have_content 'jackrlong@yahoo.com'
  end

end


end