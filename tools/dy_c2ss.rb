# $('.exchange-items')

require 'nokogiri'
base_file_name = './dy_c2ss/01-06-2021_31-08-2021'

html = File.read "#{base_file_name}.html"
doc = Nokogiri::HTML html
entries = []

doc.css('.item').each do |item|
  description = item.css('.cont-description').first.text

  if description.include?("PREGÃO") || description.include?("RECEBIMENTO DE TED") || description.include?("RETIRADA EM C/C") || description.include?("COMPRA DE OFERTA")
    next
  end

  value = item.css('.cont-value').first.text.gsub(",", ".").strip
  settlement = item.css('.settlement').first.text
  amount_and_code = description.strip.match(/\d+\s+.*/)[0].gsub("PAPEL", "").split(/\s+/)
  amount = amount_and_code[0].strip
  code = amount_and_code[1].strip

  nature = if description.include?("RENDIMENTO")
             "Rendimento"
           elsif description.include?("DIVIDENDOS")
             "Dividendos"
           else
             "JCP"
           end

  # puts "-----------"
  # puts "settlement #{settlement}"
  # puts "amount #{amount}"
  # puts "code #{code}"
  # puts "value #{value}"
  # puts "nature #{nature}"

  entries.push [code, amount, value, settlement, nature].join ";"
end

File.open("#{base_file_name}.csv", "w") do |f|
  f.write entries.reverse.join "\n"
end
