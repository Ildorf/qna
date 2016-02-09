require 'acceptance_helper'

feature 'Vote for answer or question', %q{
  In order to evaluate the publication
  As an authenticated user
  I want to be able to vote for answer or question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:own_question) { create(:question, user: user) }
  given!(:own_answer) { create(:answer, question: own_question, user: user) }


  describe 'Authenticated user' do
    before do
      sign_in user
      visit question_path(question)
    end

    scenario 'can upvote for question' do
      within '.question' do
        click_link '+'

        expect(page).to have_text '1'
      end
    end

    scenario 'can downvote for question' do
      within '.question' do
        click_link '-'

        expect(page).to have_text '-1'
      end
    end

    scenario 'can upvote for answer' do
      within "#answer_#{answer.id}" do
        click_link '+'

        expect(page).to have_text '1'
      end
    end

    scenario 'can downvote for answer' do
      within "#answer_#{answer.id}" do
        click_link '-'

        expect(page).to have_text '-1'
      end
    end


    scenario 'cannot multiple vote for question' do
      within '.question' do
        click_link '+'

        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'unvote'
      end
    end

    scenario 'cannot multiple vote for answer' do
      within "#answer_#{answer.id}" do
        click_link '-'

        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to have_link 'unvote'
      end
    end

    scenario 'can unvote for question' do
      within '.question' do
        click_link '+'

        expect(page).to have_text '1'

        click_link 'unvote'

        expect(page).to have_text '0'
      end
    end

    scenario 'can unvote for answer' do
      within "#answer_#{answer.id}" do
        click_link '+'

        expect(page).to have_text '1'

        click_link 'unvote'

        expect(page).to have_text '0'
      end
    end
  end

  scenario 'Authenticated user cannot vote for own question or answer' do
    sign_in user
    visit question_path(own_question)

    within '.question' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to_not have_link 'unvote'
    end

    within "#answer_#{own_answer.id}" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to_not have_link 'unvote'
    end
  end

  scenario 'Non-authenticated user cannot vote for question or answer' do
    visit question_path(question)

    within '.question' do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to_not have_link 'unvote'
    end

    within "#answer_#{answer.id}" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
        expect(page).to_not have_link 'unvote'
    end
  end
end