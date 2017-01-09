class Import < ActiveRecord::Base
  has_attached_file :attach, :storage => :database, :preserve_files => true;
  do_not_validate_attachment_file_type :attach																																																																						
end