class Body
  
  attr_accessor :columns, :data, :records_size
  
  def initialize
    @columns = Columns.new
    @records_size = 0
    @data = []
  end

  def column(name, label, size, type = :string)
    @columns.add({name: name, label: label,size: size, type: type})

  end 
  
  def describe_columns(&block)
    block.call self
  end
    
  
  def lines
    @records_size
  end
  
  def add_row(row)
    @data.push(row)
  end
  
end