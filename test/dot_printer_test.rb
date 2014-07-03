require 'test_helper'

class DotPrinterTest < ActiveSupport::TestCase
  
  # test "A empty report should have one page" do
  #
  #   report = DotReport.new(Body.new)
  #   assert_equal 1,report.total_pages
  # end
  #
  # test "A report that body fits page width" do
  #
  #   body = Body.new
  #
  #   body.describe_columns do |f|
  #
  #     f.column :nome,     10
  #     f.column :telefone, 20
  #     f.column :valor,    10,  :number
  #
  #   end
  #
  #   report = DotReport.new(body)
  #   assert_equal 40,report.body.columns.width
  # end
  #
  #
  # test "A report that body does not fits page width" do
  #
  #   body = Body.new
  #
  #   body.describe_columns do |f|
  #
  #     f.column :nome,     10
  #     f.column :telefone, 200
  #     f.column :valor,    10,  :number
  #
  #   end
  #   assert_raises(Exception) { DotReport.new(body) }
  # end
  
  # test "A report that only contains body" do
  #   body = Body.new
  #
  #   body.describe_columns do |f|
  #
  #     f.column :nome,     10
  #     f.column :telefone, 20
  #     f.column :valor,    10,  :number
  #
  #   end
  #
  #   class Foo
  #     attr_accessor :nome,:telefone,:valor
  #     def initialize(nome,telefone,valor)
  #       @nome = nome
  #       @telefone = telefone
  #       @valor = valor
  #     end
  #   end
  #   data = []
  #   100.times do |i|
  #     data.push(Foo.new("Joao ","55552345","122.09"))
  #   end
  #
  #   body.data = data
  #
  #   report =  DotReport.new(body)
  #   report.generate
  #   assert_equal "Joao      55552345                122.09\n" * 100, report.buffer
  # end

  test "A report that only contains body and a header" do
    
    class Foo
      attr_accessor :nome,:telefone,:valor
      def initialize(nome,telefone,valor)
        @nome = nome
        @telefone = telefone
        @valor = valor
      end
    end
    data = []
    100.times do |i|
      data.push(Foo.new("Joao ","55552345","122.09"))
    end
    
    
    
    header = Header.new
    header.describe_lines do |l|
      l.line do |f|
        f.label "COFERMETA", 12
        f.label "DATA:"
        f.value :data, 10, :string
      end
      
    end
      
    body = Body.new
    
    body.describe_columns do |f| 

      f.column :nome, "NOME", 30
      f.column :telefone,"TELEFONE", 20
      f.column :valor, "VALOR",10,  :number

    end
    
    header.values = {
      data: DateTime.now.strftime('%d/%m/%y')
    }
    
    footer = Footer.new
    footer.describe_lines do |l|
      l.line do |f|
        f.page "PÁGINA #CURRENT de #TOTAL", :center
      end
    end
    
    
    body.data = data
    
    report =  DotReport.new(body,header,footer)
    report.generate
    puts "\n"
    puts report.buffer
    #assert_equal "Joao      55552345                122.09\n" * 100, report.buffer
  end
  
  

end
