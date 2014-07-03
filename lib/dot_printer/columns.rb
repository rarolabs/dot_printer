class Columns
  attr_accessor :specs
  
  def initialize
    @specs = []
  end

  def width
    @specs.map{|e| e[:size]}.reduce(:+)
  end
  
  def add(spec)
    @specs.push(spec)
  end
  
  
  
end