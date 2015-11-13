require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
	let(:question) { create(:question) }

	describe 'POST #create' do
		context 'with valid attributes' do
			it 'save new Answer in database' do
				expect { post :create, question_id: question, answer: attributes_for(:answer) }.to change(question.answers, :count).by(1)
			end

			it 'redirects to questiion' do 
				post :create, question_id: question, answer: attributes_for(:answer)
				expect(response).to redirect_to question_path(assigns(:question))
			end
		end

		context 'with invalid attributes' do
			it 'does not save the answer' do
				expect { post :create, question_id: question, answer: attributes_for(:invalid_answer) }.to_not change(Answer, :count)
			end			

			it 'renders question' do
				post :create, question_id: question, answer: attributes_for(:invalid_answer)
				expect(response).to render_template 'questions/show'
			end
		end
	end
end