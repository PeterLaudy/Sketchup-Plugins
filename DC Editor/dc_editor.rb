# Copyright 2020 zestien3
# Licensed under the MIT license

require 'sketchup.rb'
require 'extensions.rb'

module Zestien3
  module DCEditor

    unless file_loaded?(__FILE__)
      ex = SketchupExtension.new('Zestien3 DC Editor', 'dc_editor/main')
      ex.description = 'Rudimentary Dynamic Component Editor.'
      ex.version     = '1.0.0'
      ex.copyright   = 'zestien3 © 2020'
      ex.creator     = 'Peter Laudy'
      Sketchup.register_extension(ex, true)
      file_loaded(__FILE__)
    end

  end # module DCEditor
end # module Zestien3
