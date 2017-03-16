class Hash
  def array_slice_merge!(key, array, count)
    self[key] = array.each_slice(count).collect { |e| e.reduce({}, :merge) }
  end
end
