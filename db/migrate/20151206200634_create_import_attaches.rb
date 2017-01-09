class CreateImportAttaches < ActiveRecord::Migration
  def self.up
    create_table :attaches do |t|
      t.integer    :import_id
      t.string     :style
      t.binary     :file_contents
    end
  end

  def self.down
    drop_table :attaches
  end
end
