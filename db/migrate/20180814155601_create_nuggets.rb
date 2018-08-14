class CreateNuggets < ActiveRecord::Migration
  def change
    create_table :nuggets do |t|
      t.string :user_id
      t.string :content
      t.integer :public
      t.timestamps null:false
    end
  end
end
