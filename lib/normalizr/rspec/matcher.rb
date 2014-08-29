module Normalizr
  module RSpec
    module Matcher
      def normalize(attribute)
        Normalization.new(attribute)
      end

      alias normalize_attribute normalize

      class Normalization
        def initialize(attribute)
          @attribute = attribute
          @from = ''
        end

        def description
          "normalize #{@attribute} from #{display(@from)} to #{display(@to)}"
        end

        def failure_message
          "#{@attribute} did not normalize as expected! #{display(@subject.send(@attribute))} != #{display(@to)}"
        end

        def failure_message_when_negated
          "expected #{@attribute} to not be normalized from #{display(@from)} to #{display(@to)}"
        end

        alias negative_failure_message failure_message_when_negated

        def from(value)
          @from = value
          self
        end

        def to(value)
          @to = value
          self
        end

        def matches?(subject)
          @subject = subject
          @subject.send("#{@attribute}=", @from)
          @subject.send(@attribute) == @to
        end

        protected

        def display(value)
          value.nil? ? 'nil' : "\"#{value}\""
        end
      end
    end
  end
end
