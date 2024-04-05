class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.belongs_to :commentable, null: false, polymorphic: true
      t.belongs_to :author, null: false, foreign_key: { to_table: :users }
      t.string :body, null: false

      t.timestamps
    end
  end
end
