require 'rails_helper'

feature 'Create answer', %q{
  In order to help to solve the problem
  As authenticated user
  I want to be able to create answer
} do 

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)
    fill_in 'Body', with: 'My answer'
    click_on 'Post your answer'

    expect(page).to have_content 'Your answer successfully created.'
    expect(page).to have_content 'My answer'
    expect(current_path).to eq question_path(question)
  end

end