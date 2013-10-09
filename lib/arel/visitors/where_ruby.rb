module Arel
  module Visitors
    class WhereRuby < Arel::Visitors::Visitor
      def initialize(reference_object)
        @reference_object = reference_object
      end

      private

      def visit_Arel_Nodes_Grouping o, a=nil
        visit o.expr
      end

      def visit_Arel_Nodes_GreaterThanOrEqual o, a=nil
        visit(o.left) >= visit(o.right)
      end

      def visit_Arel_Nodes_GreaterThan o, a=nil
        visit(o.left) > visit(o.right)
      end

      def visit_Arel_Nodes_LessThanOrEqual o, a=nil
        visit(o.left) <= visit(o.right)
      end

      def visit_Arel_Nodes_LessThan o, a=nil
        visit(o.left) < visit(o.right)
      end

      def visit_Arel_Nodes_Matches o, a=nil
        sql_pattern = visit(o.right)
        regex_pattern = sql_pattern.gsub(/(?<!\\)%/, '.*')  # ignore escaped '%'
        regex = Regexp.new("\\A#{regex_pattern}\\z")
        visit(o.left) =~ regex
      end

      def visit_Arel_Nodes_DoesNotMatch o, a=nil
        !visit_Arel_Nodes_Matches(o, a)
      end

      def visit_Arel_Nodes_Not o, a=nil
        !visit(o.expr)
      end

      def visit_Arel_Nodes_In o, a=nil
        if Array === o.right && o.right.empty?
          false
        else
          visit(o.right).include?(visit(o.left))
        end
      end

      def visit_Arel_Nodes_NotIn o, a=nil
        !visit_Arel_Nodes_In(o, a)
      end

      def visit_Arel_Nodes_And o, a=nil
        o.children.all? {|x| visit x }
      end

      def visit_Arel_Nodes_Or o, a=nil
        visit(o.left) || visit(o.right)
      end

      def visit_Arel_Nodes_Equality o, a=nil
        visit(o.left) == visit(o.right)
      end

      def visit_Arel_Nodes_NotEqual o, a=nil
        visit(o.left) != visit(o.right)
      end

      def visit_Arel_Attributes_Attribute o, a=nil
        @reference_object.send(o.name)
      end

      alias :visit_Arel_Attributes_Integer :visit_Arel_Attributes_Attribute
      alias :visit_Arel_Attributes_Float   :visit_Arel_Attributes_Attribute
      alias :visit_Arel_Attributes_Decimal :visit_Arel_Attributes_Attribute
      alias :visit_Arel_Attributes_String  :visit_Arel_Attributes_Attribute
      alias :visit_Arel_Attributes_Time    :visit_Arel_Attributes_Attribute
      alias :visit_Arel_Attributes_Boolean :visit_Arel_Attributes_Attribute

      def literal o, a=nil
        o
      end
      alias :visit_Bignum                        :literal
      alias :visit_Fixnum                        :literal
      alias :visit_ActiveSupport_Multibyte_Chars :literal
      alias :visit_ActiveSupport_StringInquirer  :literal
      alias :visit_BigDecimal                    :literal
      alias :visit_Class                         :literal
      alias :visit_Date                          :literal
      alias :visit_DateTime                      :literal
      alias :visit_FalseClass                    :literal
      alias :visit_Float                         :literal
      alias :visit_Hash                          :literal
      alias :visit_NilClass                      :literal
      alias :visit_String                        :literal
      alias :visit_Symbol                        :literal
      alias :visit_Time                          :literal
      alias :visit_TrueClass                     :literal

      def visit_Arel_Nodes_InfixOperation o, a=nil
        visit(o.left).send(o.operator, visit(o.right))
      end
      alias :visit_Arel_Nodes_Addition       :visit_Arel_Nodes_InfixOperation
      alias :visit_Arel_Nodes_Subtraction    :visit_Arel_Nodes_InfixOperation
      alias :visit_Arel_Nodes_Multiplication :visit_Arel_Nodes_InfixOperation
      alias :visit_Arel_Nodes_Division       :visit_Arel_Nodes_InfixOperation

      def visit_Array(o, a=nil)
        o.map {|i| visit(i) }
      end

      # I don't know when there would be multiple cores, so
      # I'm not sure how to combine them, but this seems like a reasonable guess.
      def visit_Arel_Nodes_SelectStatement(o, a=nil)
        r = visit o.cores, a
        (Array === r) ? r.all? : r
      end

      def visit_Arel_Nodes_SelectCore(o, a=nil)
        visit(o.wheres).all?
      end

      def unsupported_node o, a=nil
        raise NotImplementedError, "#would_include?() can't handle #{o.class}"
      end

      UNSUPPORTED_NODES = %w{
        DeleteStatement
        UpdateStatement
        InsertStatement
        Exists
        Values
        Bin
        Union
        UnionAll
        Intersect
        Except
        NamedWindow
        Rows
        Range
        Preceding
        Following
        CurrentRow
        Over
        Having
        Offset
        Limit
        Top
        Lock
        Group
        NamedFunction
        Extract
        Count
        Sum
        Max
        Min
        Avg
        JoinSource
        StringJoin
        OuterJoin
        InnerJoin
        On
        TableAlias
        Table
        Assignment
        BindParam
        SqlLiteral
        Between
      }.each {|n| alias :"visit_Arel_Nodes#{n}" :unsupported_node }

      def ignored_node o, a=nil
        # noop
      end

      IGNORED_NODES = %w{
        True
        False
        Distinct
        DistinctOn
        With
        WithRecursive
        Window
        Ascending
        Descending
        As
        UnqualifiedColumn
      }.each {|n| alias :"visit_Arel_Nodes#{n}" :ignored_node }

      alias :visit_Arel_SqlLiteral :unsupported_node # also deprecated
      alias :visit_Arel_SelectManager :ignored_node  # not sure if this is needed

    end
  end
end

