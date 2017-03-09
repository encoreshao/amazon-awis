class Hash
  def deep_find(key)
    key?(key) ? self[key] : self.values.inject(nil) { |memo, v| memo ||= v.deep_find(key) if v.respond_to?(:deep_find) }
  end

  def array_slice_merge!(key, array, count)
    self[key] = array.each_slice(count).collect { |e| e.reduce({}, :merge) }
  end
end
