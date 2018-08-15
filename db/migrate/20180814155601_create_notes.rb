class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :user_id
      t.string :content
      t.integer :public
      t.timestamps null:false
    end
  end
end
