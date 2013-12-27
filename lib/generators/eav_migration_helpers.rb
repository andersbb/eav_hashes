module EavMigrationHelpers

  private

  def migration_name
    migration_file_name.camelize
  end

  def table_name
    custom_table_name || "#{name}_#{hash_name}".underscore.gsub(/\//, '_')
  end

  def model_name
    name
  end

  def model_association_name
    model_name.underscore.gsub(/\//,'_')
  end

end
