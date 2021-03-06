require 'acceptance_helper.rb'

feature 'remove file from question', %q{
  In order to delete attachment from question
  As question author
  I want to be able remove file from question
} do

  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:attachment) { create(:attachment, attachable: question,) }
  
  scenario 'author remove file from question', js: true do
    sign_in(user)
    visit question_path(question)

    click_link 'Edit'

    check "remove_attachment_#{attachment.id}"
    click_on 'Save'
    
    expect(page).to_not have_content attachment.file.identifier
  end

  scenario 'another user tries to remove file from answer', js: true do
    sign_in(another_user)
    visit question_path(question)
    
    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_selector "remove_attachment_#{attachment.id}"
  end
end