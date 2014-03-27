require 'active_support/core_ext'
require 'twins/utilities'

module Twins

  # Consolidates keys with mode or lowest distance
  #
  # @param collection [Enumerable] A collection of Hash or Hash-like objects
  # @param options [Hash]
  # @return [HashWithIndifferentAccess, Nil]
  def consolidate(collection, options = {})
    return nil if collection.empty?
    ensure_collection_uniformity!(collection)

    if collection.first.is_a?(Hash)
      indiff_collection = collection
    else
      indiff_collection = collection.map { |element| element.to_hash }
    end

    options = options.with_indifferent_access
    consolidated = Hash.new

    indiff_collection.each do |element|
      element.each_pair do |key, value|
        # Recursively consolidate nested hashes
        if value.is_a?(Hash) && !consolidated[key]
          consolidated[key] = consolidate(indiff_collection.map { |el| el[key] })
        else
          # Filter elements without a given key to avoid unintentionally nil values
          values = indiff_collection.select { |el| el.has_key?(key) }.map { |el| el[key] }

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

  # Find element with the highest count of modes or the lowest overall distances
  #
  # @param collection [Enumerable] A collection of Hash or Hash-like objects
  # @param options [Hash]
  # @return [Object, Nil]
  def pick(collection, options = {})
    return nil if collection.empty?
    ensure_collection_uniformity!(collection)

    options = options.with_indifferent_access

    if options[:priority]
      pick_by_priority(collection, options[:priority])
    else
      pick_by_mode(collection)
    end
  end
  module_function :pick

  # Find the element with the highest count of modes
  #
  # @param collection [Enumerable]
  # @return [Object, Nil]
  def pick_by_mode(collection)
    return nil if collection.empty?

    if collection.first.is_a?(Hash)
      indiff_collection = collection
    else
      indiff_collection = collection.map { |element| element.to_hash.with_indifferent_access }
    end

    collection.max_by do |element|
      if collection.first.is_a?(Hash)
        indiff_element = element
      else
        indiff_element = element.to_hash.with_indifferent_access
      end

      # Build a map of modes for each existing key
      modes = indiff_element.map do |key, value|
        # Filter elements without a given key to avoid unintentionally nil values
        values = indiff_collection.select { |el| el.has_key?(key) }.map { |el| el[key] }
        [key, Twins::Utilities.mode(values)]
      end
      modes = Hash[modes]

      # Count the number of modes present in element
      modes.select { |key, mode| indiff_element[key] == mode }.count
    end
  end
  module_function :pick_by_mode

  # Find the element with the lowest overall distances
  #
  # @param collection [Enumerable]
  # @param options [Hash]
  # @return [Object, Nil]
  def pick_by_priority(collection, priorities)
    return nil if collection.empty?
    raise ArgumentError unless priorities.is_a?(Hash)

    collection.min_by do |element|
      if collection.first.is_a?(Hash)
        indiff_element = element
      else
        indiff_element = element.to_hash.with_indifferent_access
      end

      priorities.map do |key, value|
        Twins::Utilities.distance(value, indiff_element[key])
      end.sum
    end
  end
  module_function :pick_by_priority

  # @private
  def ensure_collection_uniformity!(collection)
    if collection.none? { |e| e.is_a?(Hash) || e.is_a?(collection.first.class) }
      raise ArgumentError, "The collection's elements must all be of the same Class"
    elsif collection.none? { |e| e.respond_to?(:to_hash) }
      raise ArgumentError, "The collection's elements must respond to '#to_hash'"
    end
  end
  module_function :ensure_collection_uniformity!
  private_class_method :ensure_collection_uniformity!
end
