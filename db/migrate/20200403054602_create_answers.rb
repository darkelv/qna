class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :title
      t.text :body
      t.references :question, null: false, index: true, foreign_key: true

      t.timestamps
    end
  end
end
