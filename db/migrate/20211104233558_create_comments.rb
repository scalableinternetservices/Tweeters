class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.integer :user_id
      t.integer :tweet_id
      t.text :content

      t.timestamps
    end
    add_index :comments, :user_id
    add_index :comments, :tweet_id
  end
end
