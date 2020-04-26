require 'rails_helper'

describe CommentsController, type: :controller do
  let(:user) { create(:user_with_questions, questions_count: 1) }
  let!(:question) { user.questions.first }
  let(:answer) { create(:answer, question: user.questions.first, user: user) }

  describe 'POST #create' do
    context 'with question' do
      context 'as User' do
        before { login(user) }

        context 'with valid attributes' do
          it 'saves a new comment in the database' do
            expect { post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js } }
              .to change(Comment, :count).by(1)
          end

          it 'saves as the comment of correct question' do
            post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }

            created_comment = Comment.order(:created_at).last
            expect(created_comment.commentable).to eq(question)
          end

          it 'saves as the comment of correct answer' do
            post :create, params: { comment: attributes_for(:comment), answer_id: answer, format: :js }

            created_comment = Comment.order(:created_at).last
            expect(created_comment.commentable).to eq(answer)
          end

          it 'saves as the comment of correct user' do
            post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }

            created_comment = Comment.order(:created_at).last
            expect(created_comment.user).to eq(user)
          end

          it 'redirects to show view' do
            post :create, params: { comment: attributes_for(:comment), question_id: question, format: :js }
            expect(response).to render_template :create
          end
        end

        context 'with invalid attributes' do
          it 'does not save the comment' do
            expect { post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), format: :js } }
              .not_to change(Comment, :count)
          end

          it 're-renders new view' do
            post :create, params: { question_id: question, comment: attributes_for(:comment, :invalid), format: :js }

            expect(response).to render_template :create
          end
        end
      end

      context 'as Guest' do
        it 'does not save the comment' do
          expect { post :create, params: { question_id: question, comment: attributes_for(:comment), format: :js } }
            .not_to change(Comment, :count)
        end
      end
    end
  end
end
