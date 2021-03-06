require 'acceptance_helper'

feature 'User sign up', %q{
  In order to be able completly use application
  As an user
  I want to be able sign up
} do 

  before { visit new_user_registration_path }

  scenario 'User try to sign up' do
    user_attributes = attributes_for(:user)

    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]
    fill_in 'Password confirmation', with: user_attributes[:password_confirmation]
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'User try to sign up with invalid data' do
    user_attributes = attributes_for(:invalid_user)

    fill_in 'Email', with: user_attributes[:email]
    fill_in 'Password', with: user_attributes[:password]
    fill_in 'Password confirmation', with: user_attributes[:password_confirmation]
    click_button 'Sign up'

    expect(page).to have_content 'error'
  end
end