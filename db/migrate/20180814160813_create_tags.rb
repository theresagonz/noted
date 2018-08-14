class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :word
    end
  end
end
