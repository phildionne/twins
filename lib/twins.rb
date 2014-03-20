require 'active_support/core_ext'
require 'twins/utilities'

module Twins

  # @param collection [Enumerable] A collection of Hash objects
  # @param options [Hash]
  # @return [Hash, Nil]
  def consolidate(collection, options = {})
    return nil unless collection.any?

    if collection.all? { |e| e.is_a?(Hash) }
      # noop
    elsif collection.all? { |e| e.is_a?(collection.first.class) }
      collection = collection.map do |element|
        Hash[element.instance_variables.map { |name| [name.to_s.sub(/\A@/, ''), element.instance_variable_get(name)] }]
      end
    else
      raise ArgumentError, "The collection's elements must all be of the same Class"
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
end
