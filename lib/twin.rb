require 'twin/utilities'

module Twin

  # @param collection [Enumerable] A collection of Hash objects
  # @param options [Hash]
  # @return [Hash, Nil]
  def consolidate(collection, options = {})
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
            consolidated[key] = Twin::Utilities.min_distance(options[:priority][key], filtered)

          when filtered.all? { |element| element.is_a?(Numeric) }
            consolidated[key] = Twin::Utilities.min_difference(options[:priority][key], filtered)

          else
            consolidated[key] = filtered.first
          end

        # At least two are the same or all are different, with no priority, determine candidat using mode
        else
          consolidated[key] = Twin::Utilities.mode(filtered)
        end
      end
    end

    consolidated
  end
  module_function :consolidate
end
