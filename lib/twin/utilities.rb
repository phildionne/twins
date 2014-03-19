require 'amatch'

module Twin
  module Utilities

    # @param collection [Enumerable]
    # @return Object
    def mode(collection)
      collection.group_by { |n| n }.values.max_by(&:size).first
    end
    module_function :mode

    # @param a [String]
    # @param b [String]
    # @return Float
    def distance(a, b)
      Levenshtein.new(a).match(b)
    end
    module_function :distance

    # @param a [String]
    # @param collection [Array]
    # @return Float
    def min_distance(a, collection)
      collection.min { |element| distance(a, element) }
    end
    module_function :min_distance

    # @param a [String]
    # @param collection [Array]
    # @return Float
    def max_distance(a, collection)
      collection.max { |element| distance(a, element) }
    end
    module_function :max_distance

    # @param i [Numeric]
    # @param collection [Array]
    # @return Float
    def min_difference(i, collection)
      collection.min { |element| (i - element).abs }
    end
    module_function :min_difference

    # @param i [Numeric]
    # @param collection [Array]
    # @return Float
    def max_difference(i, collection)
      collection.max { |element| (i - element).abs }
    end
    module_function :max_difference
  end
end
