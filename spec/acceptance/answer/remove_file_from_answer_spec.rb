require 'acceptance_helper.rb'

feature 'remove file from answer', %q{
  In order to delete attachment from answer
  As answer author
  I want to be able remove file from answer
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { create(:answer, question: question, user: user) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  
  scenario 'author remove file from question', js: true do
    sign_in(user)
    visit question_path(question)

    within '.answers' do
      click_link 'Edit'

      check "remove_attachment_#{attachment.id}"
      click_on 'Save'
    end

    expect(page).to_not have_content attachment.file.identifier
  end

  scenario 'another user tries to remove file from question', js: true do
    sign_in(another_user)
    visit question_path(question)
     expect(page).to_not have_link 'Edit'
    expect(page).to_not have_selector "remove_attachment_#{attachment.id}"
  end
end