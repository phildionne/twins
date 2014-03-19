

class Twin
  include Gem::Text

  # @param collection [Enumerable] A collection of Hash objects
  # @param options [Hash]
  # @return [Hash, Nil]
  def self.consolidate(collection, options = {})
    raise ArgumentError, "The collection's elements must all be of type 'Hash'" unless collection.all? { |e| e.is_a?(Hash) }
    return nil unless collection.any?

    consolidated = Hash.new

    collection.each do |hash|
      hash.each_key do |key|
        # Filter elements without a given key to avoid unintentionally nil values
        filtered = collection.select { |element| element.has_key?(key) }.map { |element| element[key] }

        # All differents, determine candidat using priority
        if filtered.uniq.none? && options[:priority][key]

          case
          when filtered.all? { |element| element.is_a?(String) }
            consolidated[key] = min_distance(options[:priority][key], filtered)

          when filtered.all? { |element| element.is_a?(Numeric) }
            consolidated[key] = min_difference(options[:priority][key], filtered)

          else
            consolidated[key] = filtered.first
          end

        # At least two are the same or all are different, with no priority, determine candidat using mode
        else
          consolidated[key] = mode(filtered)
        end
      end
    end

    consolidated
  end

  # @param collection [Enumerable]
  # @return Object
  def self.mode(collection)
    collection.group_by { |n| n }.values.max_by(&:size).first
  end

  # @param a [String]
  # @param b [String]
  # @return Float
  def self.distance(a, b)
    levensthein_distance(a, b)
  end

  # @param a [String]
  # @param collection [Array]
  # @return Float
  def self.min_distance(a, collection)
    collection.min { |element| distance(a, element) }
  end

  # @param a [String]
  # @param collection [Array]
  # @return Float
  def self.max_distance(a, collection)
    collection.max { |element| distance(a, element) }
  end

  # @param i [Numeric]
  # @param collection [Array]
  # @return Float
  def self.min_difference(i, collection)
    collection.min { |element| (i - element).abs }
  end

  # @param i [Numeric]
  # @param collection [Array]
  # @return Float
  def self.max_difference(i, collection)
    collection.max { |element| (i - element).abs }
  end
end
end

