clear = "
15/07/202115/07/2021* PROV * RENDIMENTO 60 PAPEL HGRE1182,80R$ 47.544,78
15/07/202115/07/2021* PROV * RENDIMENTO 95 PAPEL HGCR11137,75R$ 47.461,98
15/07/202115/07/2021* PROV * RENDIMENTO 75 PAPEL DEVA1183,25R$ 47.324,23
15/07/202115/07/2021* PROV * RENDIMENTO 12 PAPEL BRCR115,52R$ 47.240,98
"

clear.split("\n").each do |line|
  next if line.strip == ""
  parts = line.split(/\s+/)

  date = line.slice(0..10)
  amount = parts[4]
  code = parts[6].slice(0..5)
  dividents = parts[6].slice(6..-1).split("R$").first.gsub(".", "").gsub(",", ".")

  entries = [code, amount, dividents, "0.00", dividents, date]
  puts entries.join ";"

  # puts line
  # puts line.slice(0..10)

  # puts parts[4]
  # puts parts[6].slice(0..5)
  # puts parts[6].slice(5..-1).split("R$").first.gsub(",", ".")
  # puts "----------------"

end
