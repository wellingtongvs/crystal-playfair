require "./playfair"

def readFile
  print "Please input the name of the file: "
  filename = gets
  if filename
    filename = filename.chomp
    if !File.exists?(filename)
      puts "Error: no such file"
      exit(1)
    end
  else
    exit(1)
  end
  file = File.read(filename)
  if !file
    puts "Error: file not found"
    exit(1)
  else
    file = file.chomp.tr("àáäâãèéëẽêìíïîĩòóöôõùúüûũñçÀÁÄÂÃÈÉËẼÊÌÍÏÎĨÒÓÖÔÕÙÚÜÛŨÑÇ", "aaaaaeeeeeiiiiiooooouuuuuncAAAAAEEEEEIIIIIOOOOOUUUUUNC")
  end
  return file
end

def main
  puts "Playfair - Crystal Implementation"

  option = 0

  while ((option != 1) && (option != 2))
    puts "Please choose one of the following options:"
    puts "1 - Encrypt ASCII file"
    puts "2 - Decrypt ASCII file"
    option = gets
    if option
      option = option.to_i
    end
  end

  input_text = readFile

  print "Please input the key: "
  key = gets

  if option == 1
    text = PlayfairCipher.encrypt(input_text, key)
  else
    text = PlayfairCipher.decrypt(input_text, key)
  end

  puts text
end

main
