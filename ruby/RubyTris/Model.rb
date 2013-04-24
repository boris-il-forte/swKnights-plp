module Model
  
  
  class TrisMatrixState
    
    attr_reader :table
    
    def initialize()
      @table = [[0, 0, 0], 
                [0, 0, 0], 
                [0, 0, 0]]
    end
    
    #Inserisce la nella posizione selezionata in base a chi è il giocatore
    def insert(row, column, player)
      
      if table[row][column] == 0
	table[row][column] = player
      else
	raise InvalidMove.new("Cell has already been filled") , "cell is busy!", caller 
      end
      
    end
    
  end
  
  class InvalidMove < Exception 
    
    attr_reader :message
    
    def initialize(msg)
      @message = msg    
    end
    
  end
  
  #Da qui in poi è tutto debug per capire un po' il linguaggio
  
  t = TrisMatrixState.new()
  
  t.insert(2, 2, 1)
  
  #inizio a gestire l'eccezione in caso si verifichi
  #begin
    t.insert(2, 2, 1)
  #rescue InvalidMove => details
   #   print details.message
  #end
    
  
  print t.table[2][2]
  print "\n"
  
end
    
    
