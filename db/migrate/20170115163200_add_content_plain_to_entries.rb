class AddContentPlainToEntries < ActiveRecord::Migration[5.0]
  def change
    add_column :entries, :content_plain, :text
    add_index :entries, :content_plain
  end
end
