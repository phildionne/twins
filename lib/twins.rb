require 'active_support/core_ext'
require 'twins/utilities'

module Twins

  # Consolidates keys with mode or lowest distance
  #
  # @param collection [Enumerable] A collection of Hash or Hash-like objects
  # @param options [Hash]
  # @return [HashWithIndifferentAccess, Nil]
  def consolidate(collection, options = {})
    return nil unless collection.any?
    ensure_collection_uniformity!(collection)

    else
    end

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
            distances = values.map { |f| Twins::Utilities.distance(options[:priority][key], f) }

            # The best candidate is the first element with the shortest distance
            consolidated[key] = values[distances.index(distances.min)]
          else
            # The best candidate is the mode or the first one
            consolidated[key] = Twins::Utilities.mode(values)
          end
        end
      end
    end

    consolidated.with_indifferent_access
  end
  module_function :consolidate
  # @private
  def ensure_collection_uniformity!(collection)
    if collection.none? { |e| e.is_a?(Hash) || e.is_a?(collection.first.class) }
      raise ArgumentError, "The collection's elements must all be of the same Class"
    elsif collection.none? { |e| e.respond_to?(:to_h) }
      raise ArgumentError, "The collection's elements must respond to '#to_h'"
    end
  end
  module_function :ensure_collection_uniformity!
  private_class_method :ensure_collection_uniformity!
end
