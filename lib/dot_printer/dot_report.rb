class DotReport
  
  attr_accessor :header,:body,:footer,:setup,:total_pages,:buffer
  
  def initialize(body, header = nil, footer = nil, config = {})
    @body = body
    @header = header.nil? ? Header.new : header
    @footer = footer.nil? ? Footer.new : footer
    @config = config
    


    @config[:columns]       ||= 132 
    @config[:lines]         ||= 63
    @config[:filename]      ||= ''
    @config[:printer]       ||= ''
    @config[:type]          ||= :return_buffer
    @config[:keep_file]     ||= :false

    
    @lines_per_page = (config[:lines] - (@header.lines.size - @footer.lines.size)) - 4
    @total_pages = @body.lines > 0 ? (@body.lines.to_f /  @lines_per_page).ceil : 1
    @current_page = 1
    @data = []
    validates    

    @buffer = ""
  end


  def validates

    if header.max_width > @config[:columns]
      raise "Header exceds columns width: #{header.max_width} to #{@config[:columns]}"
    end
    
    if header.lines.size > @config[:lines]
      raise "Header exceds lines limit: #{header.lines} to #{@config[:columns]}"
    end
      
    if body.columns.width > @config[:columns]
      raise "Body exceds columns width: #{body.columns.width} to #{@config[:columns]}"
    end

    if footer.max_width > @config[:columns]
      raise "Footer exceds columns width: #{footer.max_width} to #{@config[:columns]}"
    end
    
    if footer.lines.size > @config[:lines]
      raise "Footer exceds lines limit: #{footer.lines} to #{@config[:columns]}"
    end
    
  end
  
  def generate
    body.data.each_slice(@lines_per_page).each do |slice|
      print_header
      print_page(slice)
      print_footer
      @current_page+=1
    end
    if @config[:type] == :return_buffer
      return @buffer
    else
      return print
    end
    
  end
  
  
  private 
  
  def print
    f = File.open(@config[:filename],'w')
    f << @buffer
    f.close
    `lp -d #{@config[:printer]} -o cpi=17 -o lpi=6 #{File::absolute_path(f)}`
    unless @config[:keep_file]
       File::delete(f)
    end
  end
  
  def print_footer
    print_section(@footer)
  end
  
  def print_header
    print_section(@header)
  end
  
  def print_section(section)
    section.lines.each do |line|
      line.each do |field|
        if field[:kind] == :label
          @buffer << field[:name].to_s.ljust(field[:size], ' ')
        elsif field[:kind] == :repeat
          @buffer << (field[:char].to_s * @config[:columns] )
        elsif field[:kind] == :page
          v = field[:format].to_s.gsub(/#CURRENT/,@current_page.to_s).gsub(/#TOTAL/,@total_pages.to_s)
          if field[:align] == :right
            @buffer << v.rjust( @config[:columns], ' ')
          elsif field[:align] == :center
            pos =  (@config[:columns] / 2) + (v.size / 2)
            @buffer << v.rjust(pos, ' ')
          else
            @buffer << v
          end
            
        else
          @buffer << section.values[field[:name]].to_s.ljust(field[:size], ' ')
        end
      end
      break_line
    end
  end
  
  def print_page(data)
    
    print_border
    print_labels
    print_border
    
    data.each do |record|
      body.columns.specs.each do |col|
        value = record[col[:name]]
        value = value.to_s.slice(0,col[:size])
        print_value(value,col)
      end
      @buffer << "|"
      break_line
    end
    print_border    
  end
  
  def print_labels
    body.columns.specs.each_with_index do |col,i|
      @buffer << "|" + col[:label].ljust(col[:size], ' ')
    end
    @buffer << "|"
    break_line

  end
  
  def print_border
    body.columns.specs.each_with_index do |col,i|
      @buffer << "+" + ("-" * (col[:size] ))
    end
    @buffer << "+"
    break_line
  end
  
  
  def print_value(value,col)
    if col[:type] == :string
      @buffer << "|" + value.ljust(col[:size], ' ')
    else
      @buffer << "|" +  value.rjust(col[:size], ' ')
    end
  end
  
  def break_line
    @buffer << "\n"
  end
  
  def remote_print(printer)
    
  end
  
end