class CreatePosts < ActiveRecord::Migration[7.2]
  def change
    create_table :posts do |t|
      t.string :title, null: false, limit: 100
      t.text :content, null: false
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      
      t.timestamps null: false

      t.index :created_at
    end
  end
end