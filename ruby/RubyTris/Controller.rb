require "./Model"

module Controller
  
  
  class Reasoner
    
    attr_reader :player
    attr_accessor :computerPlay
    
    def initialize
      @player = +1 #Il computer è rappresentato da un +1 (la X ? o la O :D come preferite!)
      @computerPlay = true
      
    end
    
    
    @@instance = Reasoner.new
    
    def self.instance
      return @@instance
    end
    
    private_class_method :new #per avere un singleton
    
    
    
    def minMax(node)
      hash = { }
      value = []
      
      for child in node.getChild(@player) ##max è il primo che gioca
	utility = min_value(child)
	puts utility
	hash[utility] = child
	value << utility
      end
      
      return hash[max_vector(value)]
      
      
    end
    
    def max_vector(vector)
     
      max = vector[0]
      for i in 0..vector.length-1
	if vector[i] > max
	  max = vector[i]
	end
      end
      return max
      
    end
    
    
    def max_value(state)
      puts "ciao"
      return utilityFunction(state) if terminalState(state)
      
      u = -@player
      for child in state.getChild(@player)
	u = max(u, min_value(child))
      end
      return u
    end
    
    def min_value(state)
    
      return utilityFunction(state) if terminalState(state)
      
      u = @player
      for child in state.getChild(-@player)
	u = min(u, max_value(child))
      end
      return u
      
    end
      
    #funzione euristica che valuta la tipologia di uno stato: parità, vittoria, sconfitta
    #ritorna 1 in caso di vittoria, 0 pareggio, -1 altrimenti
    def utilityFunction(state)
      
      if lost(state)
	-1
      elsif win(state)
	1
      else #draw
	0
      end
	
    end

    def terminalState(state)
      win(state) || lost(state) || fullState(state)
    end
    
    #controlla se la matrice è piena
    def fullState(state)
      
      for i in 0..2
	for j in 0..2
	  if state.table[i][j] == 0
	    return false
	  end
	end
      end
      true
    end
    
    
    #uno stato è di vittoria nel caso ci sia almeno una sequenza di 3 uni di fila nella matrice
    def win(state)
      
      #controllo le colonne
      for j in 0..2
	count = 0
	for i in 0..2
	  if state.table[i][j] == 1 #controlla qua che da errore!
	    count = count + 1
	  end
	end
	return true if count == 3 #abbiamo vinto!
      end
      
      
      
      
      #controllo le righe
      for i in 0..2
	count = 0
	for j in 0..2
	  if state.table[i][j] == 1
	    count = count + 1
	  end
	end
	return true if count == 3 #abbiamo vinto!
      end
     
      
      
      
      count = 0
      #controllo le diagonali
      for i in 0..2
	if state.table[i][i] == 1
	  count = count + 1
	end
      end
      
      return true if count == 3 #abbiamo vinto!
      
      count = 0
      for i in 2..0
	if state.table[i][i] == 1
	  count = count + 1
	end
      end
      
      return true if count == 3 #abbiamo vinto!
      
      false
    end
    
    #uno stato è di sconfitta nel caso ci sia almeno una sequenza di tre meno-uno di fila nella matrice
    def lost(state)
    
     
      #controllo le colonne
      for j in 0..2
	count = 0
	for i in 0..2
	  if state.table[i][j] == -1
	    count = count + 1
	  end
	end
	return true if count == 3 #abbiamo vinto!
      end
      
      
      
      count = 0
      #controllo le righe
      for i in 0..2
	count = 0
	for j in 0..2
	  if state.table[i][j] == -1
	    count = count + 1
	  end
	end
	return true if count == 3 #abbiamo vinto!
      end
      
      
      
      count = 0
      #controllo le diagonali
      for i in 0..2
	if state.table[i][i] == -1
	  count = count + 1
	end
      end
      
      count = 0
      for i in 2..0
	if state.table[i][i] == -1
	  count = count + 1
	end
      end
      
      return true if count == 3 #abbiamo vinto!
      
      false
    end
     
    def min(x, y)
      if x < y
	  x
      else 
	y
      end
    end
      
    def max(x, y)
      if x > y
	  x
      else 
	y
      end
    end
    
    private :min, :max, :fullState, :utilityFunction, :max_value, :min_value, :max_vector
    
  end
  
  class GameHandler
    
    PLAYER = -1
    COMPUTER = 1
    
    def initialize
      
    end
    
    def playGame
    
      m = Model::TrisMatrixState.new()
      r = Reasoner.instance
      
      begin
	printTable(m)
	
	puts "inserisci la riga (0, 1 o 2): " 
	rowPlayed = gets.chomp

	puts "inserisci la colonna (0, 1 o 2): " 
	columnPlayed = gets.chomp
	
	
	
	
	begin 
	 puts "qua ci sono"
	  m.insert(0, 0, 0)
	  puts "qua ci sono"
	rescue Model::InvalidMove => exeption
	  puts exeption.message
	  puts "game will now end :("
	  return
	end
	print "prima del min max"
	#m = r.minMax(m) #gioca il computer
	
      end while true
      
    end
    
    def printTable(trisState)
      for i in 0..2
	for j in 0..2
	  print "| " 
	  if trisState.table[i][j] == 1
	    print "X"
	  elsif trisState.table[i][j] == -1
	    print "O"
	  else
	    print " "
	  end
	  print "|" if j == 2
	end
	print "\n\n"
      end
    end
    
   
  end
   #g= GameHandler.new()
   #g.playGame
  
  
  
#  -----DEBUG------
  
   t = Model::TrisMatrixState.new()
   c = Reasoner.instance
  
  for i in 0..2
    for j in 0..2
     print c.minMax(t).table[i][j]
     end
     print "\n"
  end
end

  
 