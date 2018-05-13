module PlayfairCypher
  # encrypt function
  def self.encrypt(text, key)
    # transforms the text to uppercase
    text = text.upcase.delete(' ').delete('\n')

    # sets up the playfair 5x5 matrix
    keyMatrix = keySetup(key)

    # substitutes equal consecutive letters with a special character (X) between them
    specialCases = ("A".."Z").map { |c| c * 2 }
    specialSubsts = ("A".."Z").map { |c| c + "X" + c }
    specialCases.zip(specialSubsts).each do |specialCase, specialSubst|
      text = text.gsub(specialCase, specialSubst)
    end

    # in the playfair matrix, i = j
    text = text.gsub("J", "I")

    # if the text is odd-sized, use a special character at the end (X)
    text = text + "X"

    # initializing iteration variables
    cipher_text = ""
    stack = [] of Char
    counter = 0

    text.each_char do |x|
      if (x >= 'A') && (x <= 'Z')
        stack << x # add a character to the stack
      end
      # two characters are needed to index the matrix
      while (stack.size == 2) && counter < 2
        index = 0
        iRow = iCol = jRow = jCol = shiftRowI = shiftRowJ = shiftColI = shiftColJ = 0
        # finds the index on the key matrix
        i = (keyMatrix.index(stack[0]))
        j = keyMatrix.index(stack[1])
        if (i)
          # calculates i indexing/control variables for different situations
          iRow = i/5
          iCol = i % 5
          shiftRowI = ((i + 1) % 5) + iRow * 5
          shiftColI = (i + 5) % 25
          index = (i/5)*5
        end
        if (j)
          # calculates j indexing/control variables for different situations
          jRow = j/5
          jCol = j % 5
          shiftRowJ = ((j + 1) % 5) + jRow * 5
          shiftColJ = (j + 5) % 25
          index = index + (j % 5)
        end
        # if the current two characters of the text are on the same row in the matrix
        # shift them to the right (circular shift)
        if (iRow == jRow)
          cipher_text = cipher_text + keyMatrix[shiftRowI] + keyMatrix[shiftRowJ]
          counter = counter + 1
          # else if the current two characters of the text are on the same column in the matrix
          # shift them down (also circular)
        elsif (iCol == jCol)
          cipher_text = cipher_text + keyMatrix[shiftColI] + keyMatrix[shiftColJ]
          counter = counter + 1
          # standard case
        else
          cipher_text = cipher_text + keyMatrix[index]
        end
        # swap the indexing order of the characters to find the next encrypted character
        stack = stack.swap(0, 1)
        counter = counter + 1
        # if two characters were processed, leave the loop and get two more
        if (counter == 2)
          stack = [] of Char
          counter = 0
        end
      end
    end
    return cipher_text
  end

  def self.decrypt(text, key)
    # transforms the text to uppercase
    text = text.upcase.delete(' ').delete('\n')

    # sets up the playfair 5x5 matrix
    keyMatrix = keySetup(key)

    # sets up iteration variables
    decrypted_text = ""
    stack = [] of Char
    counter = 0

    text.each_char do |x|
      stack << x # add a character to the stack
      # two characters are needed to index the matrix
      while (stack.size == 2) && counter < 2
        index = 0
        iRow = iCol = jRow = jCol = shiftRowI = shiftRowJ = shiftColI = shiftColJ = 0
        # finds the index on the key matrix
        i = (keyMatrix.index(stack[0]))
        j = keyMatrix.index(stack[1])
        if (i)
          # calculates i indexing/control variables for different situations
          iRow = i/5
          iCol = i % 5
          shiftRowI = ((i - 1) % 5) + iRow * 5
          shiftColI = (i - 5) % 25
          index = (i/5)*5
        end
        if (j)
          # calculates j indexing/control variables for different situations
          jRow = j/5
          jCol = j % 5
          shiftRowJ = ((j - 1) % 5) + jRow * 5
          shiftColJ = (j - 5) % 25
          index = index + (j % 5)
        end
        # if the current two characters of the text are on the same row in the matrix
        # shift them to the left (circular shift)
        if (iRow == jRow)
          decrypted_text = decrypted_text + keyMatrix[shiftRowI] + keyMatrix[shiftRowJ]
          counter = counter + 1
          # else if the current two characters of the text are on the same column in the matrix
          # shift them up (also circular)
        elsif (iCol == jCol)
          decrypted_text = decrypted_text + keyMatrix[shiftColI] + keyMatrix[shiftColJ]
          counter = counter + 1
          # standard case
        else
          decrypted_text = decrypted_text + keyMatrix[index]
        end
        # swap the indexing order of the characters to find the next encrypted character
        stack = stack.swap(0, 1)
        counter = counter + 1
        # if two characters were processed, leave the loop and get two more
        if (counter == 2)
          stack = [] of Char
          counter = 0
        end
      end
    end
    return decrypted_text
  end

  private def self.keySetup(key)
    keyMatrix = [] of Char
    if key
      # transforms the key to uppercase and substitutes all the ocurrences of Js for Is
      key = key.chomp.upcase.gsub("J", "I")
    else
      exit(1)
    end
    # fills out the starting positions of the matrix with unique characters from the key
    key.each_char do |c|
      if !(keyMatrix.includes?(c))
        keyMatrix << c
      end
    end
    # fills out the rest of the positions with the remaining characters
    ('A'..'Z').each do |c|
      if !(keyMatrix.includes?(c))
        if c == 'J'
          next
        end
        keyMatrix << c
      end
    end
    return keyMatrix
  end
end
