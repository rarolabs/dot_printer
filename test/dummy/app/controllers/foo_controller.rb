class FooController < ApplicationController

  def bar

    @data = []
    100.times do |i|
      @data.push(Pessoa.new("Joao ","55552345","122.09"))
    end


  end
end
