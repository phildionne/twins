hash1 = {
  title: "Mesmerise",
  artist: "Temples",
  album: "Sun",
  year: 1994
}

hash2 = {
  title: "Mesmerise",
  artist: "Temple",
  album: "Structures",
  year: 1990
}

hash3 = {
  title: "Mesmerize",
  artist: "temple",
  album: "Sun Structures",
  year: 1992
}


original = {
  title: "Mesmerise",
  artist: "Temples",
  album: "Sun Structures",
  year: nil
}


consolidated = {
  title: "Mesmerise",
  artist: "Temples",
  album: "Sun Structures",
  year: 1994
}

collection = [
  { title: "Mesmerize" },
  { title: "Mesmeriz" },
  { title: "Mesmeris" }
]

original = { title: "Mesmerise" }


options = {
  priority: {
    title: "Mesmerise"
  }
}


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


[1, 2, 3, 1]
["a", "b", "c", "a"]
arr = [{a: "a", b: "b"}, {a: "a", b: "b"}, {a: "a", b: "b", c: "c"}]

Entity.resolve(entities)

resolver = Resolver.new

# Overall distance
resolver.distance(hash1, hash2)
# => 0.89


# Probalistic
resolved.consolidated
# =>

{
  title: "title",
  artist: "Artist",
  year: 122
}


Twin.distance(hash1[:title], hash2[:title])
# => 0.90

Twin.distance(hash1, hash2)
# => 0.96


Twin.consolidate([hash1, hash2, hash3])
# => { ... }


# case object.class

# # "string"
# when String

# # 1, 1.0
# when Integer || Float

# # Nil, true, false
# when NilClass || TrueClass || FalseClass

# # {}
# when Hash

# # []
# when Array

# # object
# when object.respond_to?(:instance_variables)
#   object.instance_variables.each do |instance_variable|
#   end

# else
#   raise "Unconsolidable object"
# end



# String ->                           scored using the string's levensthein distance,   consolidated based on the score
# Integer, Float ->                   scored using the #== method,                      consolidated based on the nearest value from the mean
# NilClass, TrueClass, FalseClass ->  scored using the #== method,                      consolidated using the mean value

# Object.instance_variables

# Array
# Hash


# @param a [String]
# @param b [String]
# @return Float
def distance(a, b)
  levensthein_distance(a, b)
end

