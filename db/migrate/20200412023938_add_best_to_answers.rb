class AddBestToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :best, :boolean, null: false, default: false
    add_index :answers, [:best, :question_id], unique: true, where: 'best'
  end
end
