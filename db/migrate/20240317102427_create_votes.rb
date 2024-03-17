class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.references :voteable, null: false, polymorphic: true
      t.references :user, null: false, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end
