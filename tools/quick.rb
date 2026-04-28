formula = %w[C D E F G H I J K L M N].map do |column|
  "(#{column}2/$#{column}$42 * $#{column}$43)"
end.join(" + ")

puts formula
