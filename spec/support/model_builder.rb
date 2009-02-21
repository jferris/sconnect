module ModelBuilder
  def self.included(example_group)
    example_group.class_eval do
      before do
        @defined_constants = []
        @created_tables    = []
      end

      after do
        @defined_constants.each do |class_name| 
          Object.send(:remove_const, class_name)
        end

        @created_tables.each do |table_name|
          ActiveRecord::Base.
            connection.
            execute("DROP TABLE IF EXISTS #{table_name}")
        end
      end
    end
  end

  def create_table(table_name, &block)
    connection = ActiveRecord::Base.connection
    
    begin
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      connection.create_table(table_name, &block)
      @created_tables << table_name
      connection
    rescue Exception => exception
      connection.execute("DROP TABLE IF EXISTS #{table_name}")
      raise exception
    end
  end

  def define_constant(class_name, base, &block)
    class_name = class_name.to_s.camelize

    klass = Class.new(base)
    Object.const_set(class_name, klass)

    klass.class_eval(&block) if block_given?

    @defined_constants << class_name

    klass
  end

  def define_model_class(class_name, &block)
    define_constant(class_name, ActiveRecord::Base, &block)
  end

  def define_model(name, columns = {}, &block)
    class_name = name.to_s.pluralize.classify
    table_name = class_name.tableize

    create_table(table_name) do |table|
      columns.each do |name, type|
        table.column name, type
      end
    end

    define_model_class(class_name, &block)
  end
end
