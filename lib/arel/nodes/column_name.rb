module Arel
  module Nodes
    class ColumnName <Arel::Nodes::Node
      @@error = "column name specifier must be in the form: [<table>.]<name>[ ASC| DESC]"
      attr_reader :name, :table_name, :direction
      def initialize val
        s = val.split ' '
        if 2 == s.size 
          raise @@error unless %w(ASC DESC).include?(s[1])
          @direction = s[1]
          tc = s[0]
        else
          tc = val
        end
        vals = tc.split '.'
        case vals.size 
        when 1
          @name = vals[0]
        when 2
          @name = vals[1]
          @table_name = vals[0]
        else
          raise @@error
        end
      end
    end
  end
end

