# frozen_string_literal: true

class Hash
  def array_slice_merge!(key, array, count)
    self[key] = array.each_slice(count).collect { |e| e.reduce({}, :merge) }
  end

  def deep_find(key, object = self, found = nil)
    return object[key] if object.respond_to?(:key?) && object.key?(key)
    return found unless object.is_a?(Enumerable)

    object.find { |*a| found = deep_find(key, a.last) }
    found
  end
end
