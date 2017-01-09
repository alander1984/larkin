class CreateImports < ActiveRecord::Migration
  def up
    create_table :imports do |t|
      t.string :attach_file_name;
      t.string :attach_content_type;
      t.integer :attach_file_size;
      t.datetime :attach_updated_at;
    end
  end

  def down
  	drop_table :imports;
  end	
end
