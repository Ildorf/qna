require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
	let(:question) { create(:question, user: @user)}	
	let(:anothers_question) { create(:question)}	
	let(:answer) { create(:answer, user: @user, question: question)	 }
	let(:anothers_answer) { create(:answer, question: question) }
	
	describe 'POST #create' do
		context 'authenticated user' do
			sign_in_user
			context 'with valid attributes' do
				let(:chanel) { "/questions/#{question.id}/answers" }
        let(:do_requset) { post :create, question_id: question, answer: attributes_for(:answer), format: :js }
        
        it 'save new Answer in database' do
					expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js }.to change(question.answers, :count).by(1)
				end

				it 'render template create' do 
					do_requset 
					expect(response).to render_template  'answers/show.json.jbuilder'
				end

        it_behaves_like "publishable"
			end

			context 'with invalid attributes' do
				it 'does not save the answer' do
					expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js }.to_not change(Answer, :count)
				end			

				it 'render template create' do
					post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js 
				end
			end
		end

		context 'non-authenticated user' do
			it 'does not save answer' do
				expect { post :create, question_id: anothers_question, answer: attributes_for(:answer) }.to_not change(Answer, :count)
			end
		end
	end

	describe 'PATCH #update' do
		sign_in_user

    it 'assigns requested answer to @answer' do
      patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js 
      expect(assigns(:answer)).to eq answer     
    end
     it 'changes question attributes' do
     patch :update, question_id: question, id: answer, answer: { body: 'new body'}, format: :js 
      answer.reload
      expect(answer.body).to eq 'new body'
    end

    it 'render update template' do
      patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js 
      expect(response).to render_template :update
    end
	end

	describe 'DELETE #destroy' do
		sign_in_user

		context 'user is owner answer' do
			before { answer }

			it 'delete answer from database' do
				expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(Answer, :count).by(-1)
			end

			it 'render destroy template' do
				delete :destroy, question_id: question, id: answer, format: :js
				expect(response).to render_template :destroy
			end
		end

		context 'user is not owner answer' do
			before { anothers_answer }

			it 'does not delete answer' do
				expect { delete :destroy, question_id: question, id: anothers_answer, format: :js }.to_not change(Answer, :count)
			end
		end
	end

	describe 'PATCH #make_best' do
		sign_in_user

		before { patch :make_best, question_id: question, id: answer, format: :js  }

    it 'assigns requested answer to @answer' do
      expect(assigns(:answer)).to eq answer     
    end

    it 'it makes answer the best' do
      answer.reload
      expect(answer.best).to eq true 
    end

    it 'it makes only one answer the best' do
      patch :make_best, question_id: question, id: anothers_answer, format: :js
      answer.reload
      anothers_answer.reload

      expect(answer.best).to eq false
      expect(anothers_answer.best).to eq true
    end

    it 'render make_best template' do 
      expect(response).to render_template :make_best
    end
	end

  describe 'votable' do
    sign_in_user
    let(:votable) { create(:answer, user: @user) }
    let(:anothers_votable) { create(:answer) }
    it_behaves_like "votable"
  end

end