# encoding: UTF-8

module Bunch
  class Pipeline
    ENVIRONMENTS = {
      "development" => proc {
        [Ignorer, SimpleCache.new(Compiler), Combiner]
      },
      "production" => proc {
        [Ignorer, Compiler, Combiner, JsMinifier, CssMinifier]
      }
    }

    def self.for_environment(environment)
      proc = ENVIRONMENTS[environment] ||
        raise("No pipeline defined for #{environment}!")
      new(proc.call)
    end

    def initialize(processors)
      @processors = processors
    end

    def process(input_tree)
      tree = input_tree
      @processors.each do |processor|
        tree = processor.new(tree).result
      end
      tree
    end
  end
end
