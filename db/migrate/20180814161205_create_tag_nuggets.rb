class CreateTagNuggets < ActiveRecord::Migration
  def change
    create_table :tag_nuggets do |t|
      t.integer :tag_id
      t.integer :nugget_id
    end
  end
end
