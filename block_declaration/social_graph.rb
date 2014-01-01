require 'singleton'

module SocialGraph
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def social_graph(&block)
      social_graph_spec = Specification.new
      social_graph_spec.instance_eval(&block)
      social_graph_spec.apply_on(self)
    end
  end

  class Specification
    def initialize
      @relationships = []
    end

    def relationship(name, options)
      @relationships << Relationship.new(name, options)
    end

    def apply_on(base)
      @relationships.each do |relationship|
        relationship.apply_on(base)
      end
    end
  end

  Relationship = Struct.new(:name, :options) do
    def apply_on(base)
      self_side, other_side =
          (options[:is] == :outgoing) ?
              [ "from_#{options[:as]}", "to_#{options[:to]}" ] :
                  [ "to_#{options[:as]}", "from_#{options[:to]}" ]

      base.class_eval(<<-EOS, __FILE__, __LINE__)
        def add_#{options[:to]}(other)
          Repository.instance.add({
            relationship: :#{name},
            #{self_side}: self,
            #{other_side}: other
          })
        end

        def #{options[:to]}_list
          #{name}.collect { |relationship| relationship[:#{other_side}]  }
        end

        def #{name}
          Repository.instance.find(relationship: :#{name}, #{self_side}: self)
        end
      EOS
    end
  end

  class Repository
    include Singleton

    def initialize
      @entries = []
    end

    def add(entry)
      @entries << entry
    end

    def find(filter)
      @entries.select { |entry| filter_match?(entry, filter) }
    end

    private
    def filter_match?(entry, filter)
      entry.merge(filter) == entry
    end
  end
end