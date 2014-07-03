class Header
  attr_accessor :lines, :values
  
  def initialize
    @lines = []
    @current_line = 0
    @values = {}
  end
  
  def describe_lines(&block)
    block.call self
  end
  
  def line(&block)
    block.call self
    @current_line+=1
  end
  
  def label(name,size=0)
    size = name.size if size == 0
    @lines[@current_line] ||= []
    @lines[@current_line].push({kind: :label,name: name, size: size})
  end
  
  def value(name,size,type=:string)
    @lines[@current_line] ||= []
    @lines[@current_line].push({kind: :value,name: name, size: size})
  end
  
  def repeat(char)
    @lines[@current_line] ||= []
    @lines[@current_line].push({kind: :repeat,char: char, size: 0})
  end
  
  
  def page(format,align = :left)
    @lines[@current_line] ||= []
    @lines[@current_line].push({kind: :page, format: format, size: 0, align: align})
  end
  
  
  def max_width
    max = 0
    @lines.each do |lines|
      width  = lines.map(&:size).reduce(:+)
      max = width if width > max
    end
    max
  end
  
  

end