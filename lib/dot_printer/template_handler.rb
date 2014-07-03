# encoding: utf-8
require 'delegate'
require 'active_support/core_ext'

module DotPrinter
  
  class Engine < ::Rails::Engine
      config.autoload_paths += Dir["#{config.root}/lib/**/"]
  end
  
  class TemplateHandler
    def self.call(template)
      template.source
    end
  end
  
end

ActionView::Template.register_template_handler :dot_printer, DotPrinter::TemplateHandler