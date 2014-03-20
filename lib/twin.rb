require 'active_support/core_ext'
require 'twin/utilities'

module Twin

  # @param collection [Enumerable] A collection of Hash objects
  # @param options [Hash]
  # @return [Hash, Nil]
  def consolidate(collection, options = {})
    raise ArgumentError, "The collection's elements must all be of type 'Hash'" unless collection.all? { |e| e.is_a?(Hash) }
    return nil unless collection.any?

    options = options.with_indifferent_access
    consolidated = Hash.new

    collection.each do |hash|
      hash.each_pair do |key, value|

        # Recursively consolidate nested hashes
        if value.is_a?(Hash) && !consolidated[key]
          consolidated[key] = consolidate(collection.map { |element| element[key] })
        else
          # Filter elements without a given key to avoid unintentionally nil values
          values = collection.select { |element| element.has_key?(key) }.map { |element| element[key] }

          if options[:priority].try(:[], key)
            # Compute each element's distance from the given priority
            distances = values.map { |f| Twin::Utilities.distance(options[:priority][key], f) }

            # Find the first element with the shortest distance
            consolidated[key] = values[distances.index(distances.min)]
          else
            consolidated[key] = Twin::Utilities.mode(values)
          end
        end
      end
    end

    consolidated.with_indifferent_access
  end
  module_function :consolidate
end
