class AddSubscriptions < ActiveRecord::Migration[6.0]
  def change
    create_table :subscriptions do |t|
      t.references :question, foreign_key: true
      t.references :user, foreign_key: true
      t.timestamps
    end

    add_index(:subscriptions, [:user_id, :question_id], unique: true)
  end
end
