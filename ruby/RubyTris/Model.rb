module Model
  
  class TrisMatrixState
    
    attr_reader :table
   
    @@childcount = 0

    #può valere:1, 0 o -1 a seconda di vittoria, pareggio o sconfitta
    attr_accessor :minMaxGain
    
    def initialize()
      @table = [[0, 0, 0], 
                [0, 0, 0], 
                [0, 0, 0]]
      
      @minMaxGain = 0
    end
    
	def to_s()
			s = ""
			@table.each do |row|
				row.each do |cell|
				   s = s << cell.to_s << " "
				end
				s = s << "\n"
			end
			s
	end

    #espande lo stato corrente
    def getChild(player)
      copyState = self.copy
      children = [] #conterrà tutti i nodi figli 
      
      for i in 0..2
	for j in 0..2
	  begin 
	   copyState.insert(i, j, player)
	   @@childcount += 1
	   children << copyState
	   copyState = self.copy
	  rescue InvalidMove => exception
	  end
	end
      end
      
      children
    end
    
    def copy
      copy = TrisMatrixState.new
      copy.minMaxGain = @minMaxGain
      
      for i in 0..2
	for j in 0..2
	  copy.table[i][j] = @table[i][j]
	end
      end
      copy
    end
    
    #Inserisce la nella posizione selezionata in base a chi è il giocatore #lancia eccezione se cella occupata
    def insert(row, column, player)
      
      if table[row][column] == 0
	table[row][column] = player
      else
	raise InvalidMove.new("Cell has already been filled") , "cell is busy!", caller 
      end
      
    end
    
  end
  
  #definisco un'eccezione per gestire il caso di mossa non valida
  class InvalidMove < Exception 
    
    attr_reader :message
    
    def initialize(msg)
      @message = msg    
    end
    
  end
  
  #Da qui in poi è tutto debug per capire un po' il linguaggio
  
  
  


  
  
end
    
    
