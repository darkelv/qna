class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.references :user, index: true, foreign_key: true, null: false
      t.integer :votable_id
      t.string :votable_type
      t.integer :voice, default: 1, null: false

      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type]
  end
end
