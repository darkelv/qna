class AddUserToQuestionAndAnswer < ActiveRecord::Migration[6.0]
  def change
    add_reference :answers, :user, null: false, index: true, foreign_key: true
    add_reference :questions, :user, null: false, index: true, foreign_key: true
  end
end
