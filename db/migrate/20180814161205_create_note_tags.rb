class CreateNoteTags < ActiveRecord::Migration
  def change
    create_table :note_tags do |t|
      t.integer :tag_id
      t.integer :note_id
    end
  end
end
