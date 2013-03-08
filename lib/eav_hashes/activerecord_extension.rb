module ActiveRecord
  module EavHashes
    def self.included (base)
      base.extend ActiveRecord::EavHashes::ClassMethods
    end

    module ClassMethods
      def eav_hash_for (hash_name, options={})
        # Fill in default options not otherwise specified
        options[:hash_name] = hash_name
        options[:parent_class_name] = self.name.to_sym
        options = ActiveRecord::EavHashes::Util::fill_options_hash options

        # Store the options hash in a class variable to create the EavHash object
        # if and when it's actually used.
        class_variable_set "@@#{hash_name}_hash_options".to_sym, options

        # Create the association, the entry update hook, and a helper method to lazy-load the entries
        class_eval <<-END_EVAL
          has_many :#{options[:entry_assoc_name]}, class_name: #{options[:entry_class_name]}, foreign_key: "#{options[:parent_assoc_name]}_id"
          after_save :save_#{hash_name}
          def #{hash_name}
            @#{hash_name} ||= ActiveRecord::EavHashes::EavHash.new(self, @@#{hash_name}_hash_options)
          end

          def save_#{hash_name}
            @#{hash_name}.save_entries if @#{hash_name}
          end

          def self.find_by_#{hash_name} (key, value=nil)
            self.find (ActiveRecord::EavHashes::Util::run_find_expression(key, value, @@#{hash_name}_hash_options))
          end
        END_EVAL

        # If we have a key constraints table, set up method_missing and respond_to_missing
        # to provide accessors for the key names.
        if options[:constraint_model]
          class_eval <<-END_EVAL
            def key_names
              @key_names ||= #{options[:constraint_model]}.to_s.constantize.all.collect(&:#{options[:constraint_column]})
            end

            def method_missing(method_name, *args, &block)
              meth = method_name.to_s
              if key_names.include? meth
                #{hash_name}[meth]
              elsif meth =~ /.+=$/ && key_names.include?(meth.slice(0..-2))
                #{hash_name}[meth.slice(0..-2)] = args[0]
              else
                super
              end
            end

            def respond_to_missing?(method_name, include_private = false)
              meth = method_name.to_s
              if key_names.include?(meth) || (meth =~ /.+=$/ && key_names.include?(meth.slice(0..-2)))
                true
              else
                super
              end
            end
          END_EVAL
        end
      end
    end
  end
end
