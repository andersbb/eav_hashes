require 'rails/generators'
require 'rails/generators/active_record'

class EavMigrationGenerator < ActiveRecord::Generators::Base

  source_root File.expand_path "../templates", __FILE__
  source_root File.expand_path "../..", __FILE__

  include EavMigrationHelpers

  # small hack to override NamedBase displaying NAME
  argument :name, :required => true, :type => :string, :banner => "<ModelName>"
  argument :hash_name, :required => true, :type => :string, :banner => "<hash_name>"
  argument :custom_table_name, :required => false, :type => :string, :banner => "table_name"

  def create_eav_migration
    p name
    migration_template "eav_typed_migration.erb", "db/migrate/#{migration_file_name}.rb"
  end

end