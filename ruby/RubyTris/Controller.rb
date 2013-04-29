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
      vector.each { |x|
			  if x > max
					  max = x
			  end
	  }
	  max
    end
    
    
    def max_value(state)
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
			return -1 if lost(state)
			return 1 if win(state)
			0
    end

    def terminalState(state)
	  win(state) or lost(state) or fullState(state)
    end
    
    #controlla se la matrice è piena
    def fullState(state)
      state.table.each { |row|
			  row.each { |x|
					 return false if x == 0
			  }
	  }
	  true
    end
    
    #uno stato è di vittoria nel caso ci sia almeno una sequenza di 3 uni di fila nella matrice
    def win(state)
			playerWon(state, +1)
	end

	def lost(state)
			playerWon(state, -1)
	end

	def playerWon(state, player)
      #controllo le colonne
      for j in 0..2
	     count = 0
	     for i in 0..2
	        if state.table[i][j] == player #controlla qua che da errore!
	           count = count + 1
	        end
	     return true if count == 3 #abbiamo vinto!
	     end
      end
      
      #controllo le righe
      for i in 0..2
	     count = 0
	     for j in 0..2
	        if state.table[i][j] == player
	        count = count + 1
	        end
	     return true if count == 3 #abbiamo vinto!
	     end
      end
     
      count = 0
      #controllo le diagonali
      for i in 0..2
         if state.table[i][i] == player
	        count = count + 1
	     end
      end
      return true if count == 3 #abbiamo vinto!
      
      count = 0
      for i in 2..0
         if state.table[i][2-i] == player
	        count = count + 1
	     end
      end
      return true if count == 3 #abbiamo vinto!
      
      false
    end
    
    def min(x, y)
      x < y ? x : y
    end
      
    def max(x, y)
      x > y ? x : y
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

  
 
