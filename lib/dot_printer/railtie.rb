require 'rails'

module DotPrinter
    
  class Railtie < ::Rails::Railtie
    initializer 'dot-report' do
      ::ActiveSupport.on_load(:action_view) do
        ::Mime::Type.register('text/plain', :dot_printer) 
        require "dot_printer/template_handler.rb"
      end
    end
  end
end