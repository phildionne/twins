require 'amatch'

module Twin
  module Utilities

    # @param collection [Enumerable]
    # @return [Object]
    def mode(collection)
      collection.group_by { |n| n }.values.max_by(&:size).first
    end
    module_function :mode

    # Normalized distance for Strings and Numerics
    # the lower the result, the shortest the distance
    #
    # @param a [String, Numeric]
    # @param b [String, Numeric]
    # @return [Float]
    def distance(a, b)
      if a.is_a?(String) && b.is_a?(String)
        Twin::Utilities.string_distance(a, b) * -1
      elsif a.is_a?(Numeric) && b.is_a?(Numeric)
        Twin::Utilities.numeric_distance(a, b)
      else
        raise StandardError, "Distance can only be determined between two elements of kind 'String' or 'Numeric'"
      end
    end
    module_function :distance

    # @param a [String]
    # @param b [String]
    def string_distance(a, b)
      raise StandardError, "Distance can only be determined between two elements of kind 'String'" unless a.is_a?(String) && b.is_a?(String)
      Amatch::LongestSubsequence.new(a).match(b)
    end
    module_function :string_distance

    # @param a [Numeric]
    # @param b [Numeric]
    def numeric_distance(a, b)
      raise StandardError, "Distance can only be determined between two elements of kind 'Numeric'" unless a.is_a?(Numeric) && b.is_a?(Numeric)
      (a - b).abs
    end
    module_function :numeric_distance
  end
end
