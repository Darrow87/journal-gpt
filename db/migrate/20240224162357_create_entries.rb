# Migration for Entry model
class CreateEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :entries do |t|
      t.string :title
      t.date :date
      t.jsonb :content, default: {}
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
