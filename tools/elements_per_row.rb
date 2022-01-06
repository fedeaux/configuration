def list_elements_per_row_options(from: 2, to: 20, container_dimension:, container_padding:, gutter:)
  available_space = container_dimension - container_padding * 2

  (from..to).map do |n|
    outer_width = (available_space / n).to_i
    "#{n} items of #{outer_width - gutter * 2}px"
  end.join "\n"
end

# Candlesticks per row
list_elements_per_row_options(
  container_dimension: 1920,
  container_padding: 4,
  gutter: 4
)

# Candlesticks per column
puts list_elements_per_row_options(
  container_dimension: 912,
  container_padding: 4,
  gutter: 4
)
