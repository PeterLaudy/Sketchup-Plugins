# Copyright 2020 zestien3
# Licensed under the MIT license

require 'sketchup.rb'

module Zestien3
  module DCEditor

    @@dialog = nil

    def self.add_attributes_html
      if (@@dialog.nil?)
        @@dialog = UI::HtmlDialog.new(
          {
            :dialog_title => "Zestien3 DC Editor",
            :preferences_key => "com.sample.plugin",
            :scrollable => true,
            :resizable => true,
            :width => 600,
            :height => 400,
            :left => 100,
            :top => 100,
            :min_width => 50,
            :min_height => 50,
            :max_width =>1000,
            :max_height => 1000,
            :style => UI::HtmlDialog::STYLE_DIALOG
          })
        @@dialog.set_html(%{
<!DOCTYPE html>
<html>
  <head>
    <title>Zestien3 DC Editor</title>
  </head>
  <style>
    body {
      font-family: sans-serif;
    }
    button, select, table, p, input {
      width: 100%;
    }
    button{
      background-color: blue;
      color: white;
      font-size: 16px;
      margin-top: 8px;
    }
    hr {
      margin-top: 16px;
      margin-bottom: 12px;
      border-color: black;
    }
  </style>
  <script>
    function saveAttrDef(varName, attrName) {
      var element = document.getElementById(attrName);
      if (element.disabled || (element.value == "")) {
        sketchup.del_attribute_def("_" + varName + "_" + attrName);
      } else {
        sketchup.set_attribute_def("_" + varName + "_" + attrName, document.getElementById(attrName).value);
      }
    }
    function saveAttrInst(varName, attrName) {
      var element = document.getElementById(attrName);
      if (element.disabled || (element.value == "")) {
        sketchup.del_attribute_def(varName + attrName);
      } else {
        sketchup.set_attribute_def(varName + attrName, document.getElementById(attrName).value);
      }
    }
    function saveDefinition() {
      if (document.getElementById("param").value == "var") {
        saveParameter();
      } else {
        saveAttribute();
      }
    }
    function saveParameter() {
      var varName = document.getElementById("label").value;
      saveAttrDef(varName, "label");
      saveAttrDef(varName, "access");
      saveAttrDef(varName, "formlabel");
      saveAttrDef(varName, "options");
      saveAttrDef(varName, "units");
      saveAttrDef(varName, "formula");
    }
    function saveAttribute() {
      var varName = document.getElementById("param").value;
      if (varName.charAt(0) == "_") {
        saveAttrInst(varName, "label");
        saveAttrInst(varName, "access");
        saveAttrInst(varName, "formlabel");
        saveAttrInst(varName, "options");
        saveAttrInst(varName, "units");
        saveAttrInst(varName, "formula");
      } else {
        sketchup.set_attribute_def(varName, document.getElementById("formula").value);
      }
    }
    function saveInstance() {
      sketchup.set_attribute_inst(document.getElementById("inst_param").value, document.getElementById("inst_formula").value);
    }
    function initialize() {
      sketchup.init_attributes(
        document.getElementById("cmp_name").value,
        document.getElementById("len_units").value
      );
    }
    function deleteAttrDef(varName, attrName) {
      sketchup.del_attribute_def("_" + varName + "_" + attrName);
    }
    function deleteAttrInst(varName, attrName) {
      sketchup.del_attribute_def(varName + attrName);
    }
    function deleteDefinition() {
      if (document.getElementById("param").value == "var") {
        deleteParameter();
      } else {
        deleteAttribute();
      }
    }
    function deleteParameter() {
      var varName = document.getElementById("label").value;
      deleteAttrDef(varName, "label");
      deleteAttrDef(varName, "access");
      deleteAttrDef(varName, "formlabel");
      deleteAttrDef(varName, "options");
      deleteAttrDef(varName, "units");
      deleteAttrDef(varName, "formula");
    }
    function deleteAttribute() {
      var varName = document.getElementById("param").value;
      if (varName.charAt(0) == "_") {
        deleteAttrInst(varName, "label");
        deleteAttrInst(varName, "access");
        deleteAttrInst(varName, "formlabel");
        deleteAttrInst(varName, "options");
        deleteAttrInst(varName, "units");
        deleteAttrInst(varName, "formula");
      } else {
        sketchup.del_attribute_def(varName);
      }
    }
    function deleteInstance() {
      sketchup.del_attribute_inst(document.getElementById("inst_param").value);
    }
    function deleteAllDefinition() {
      sketchup.delete_attributes_def();
    }
    function deleteAllInstance() {
      sketchup.delete_attributes_inst();
    }
    function enableLabel() {
      if (document.getElementById("access").value == "NONE") {
        document.getElementById("formlabel").disabled = true;
      } else {
        document.getElementById("formlabel").disabled = false;
      }
      if (document.getElementById("access").value == "LIST") {
        document.getElementById("options").disabled = false;
      } else {
        document.getElementById("options").disabled = true;
      }
    }
  </script>
  <body>
    Component name<input type="text" id="cmp_name">
    <label for="len_units">Units</label>
    <select id="len_units">
      <option value="DEFAULT">Default</option>
      <option value="CENTIMETERS">Centimeters</option>
      <option value="MILLIMETERS">Millimeters</option>
      <option value="METERS">Meters</option>
      <option value="INCHES">Inches</option>
    </select></td><tr>
    <button onclick="initialize()">Initialize</button>
	<button onclick="sketchup.show_info()">Show info</button>
    <hr>
    <table>
      <tr><td>Parameter</td><td>
      <select id="param">
        <option value="var">Variable</option>
        <option value="_inst__x_">X position</option>
        <option value="_inst__y_">Y position</option>
        <option value="_inst__z_">Z position</option>
        <option value="_inst__lenx_">X Length</option>
        <option value="_inst__leny_">Y Length</option>
        <option value="_inst__lenz_">Z Length</option>
        <option value="_inst__rotx_">X angle</option>
        <option value="_inst__roty_">Y angle</option>
        <option value="_inst__rotz_">Z angle</option>

        <option value="material">Material</option>
        <option value="scale">Scale tool</option>
        <option value="hidden">Hidden</option>
        <option value="onclick">onClick</option>
        <option value="copies">Copies</option>
      </select></td><tr>
      <tr><td>Access</td><td>
      <select id="access" onchange="enableLabel()">
        <option value="NONE">None</option>
        <option value="VIEW">View</option>
        <option value="TEXTBOX">Text</option>
        <option value="LIST">List</option>
      </select></td><tr>
      <tr><td>Label</td><td><input type="text" id="formlabel" disabled="disabled"></td></tr>
      <tr><td>Name</td><td><input type="text" id="label"></td></tr>
      <tr><td>Options</td><td><input type="text" id="options" disabled="disabled"></td></tr>
      <tr><td>Units</td><td><input type="text" id="units"></td></tr>
      <tr><td>Formula</td><td><input type="text" id="formula"></td></tr>
    </table>
    <button onclick="saveDefinition()">Set on definition</button>
    <button onclick="deleteDefinition()">Remove from definition</button>
    <button onclick="deleteAllDefinition()">Remove all from definition</button>
    <hr>
    <table>
      <tr><td>Parameter</td><td>
      <select id="inst_param">
        <option value="_x_formula">X position</option>
        <option value="_y_formula">Y position</option>
        <option value="_z_formula">Z position</option>
        <option value="_lenx_formula">X Length</option>
        <option value="_leny_formula">Y Length</option>
        <option value="_lenz_formula">Z Length</option>
        <option value="_rotx_formula">X angle</option>
        <option value="_roty_formula">Y angle</option>
        <option value="_rotz_formula">Z angle</option>

        <option value="material">Material</option>
        <option value="scale">Scale tool</option>
        <option value="hidden">Hidden</option>
        <option value="onclick">onClick</option>
        <option value="copies">Copies</option>
      </select></td><tr>
      <tr><td>Formula</td><td><input type="text" id="inst_formula"></td></tr>
    </table>
    <button onclick="saveInstance()">Set on instance</button>
    <button onclick="deleteInstance()">Remove from instance</button>
    <button onclick="deleteAllInstance()">Remove all from instance</button>
  </body>
</html>
        })
        @@dialog.add_action_callback("init_attributes") { | action_context, cmp_name, units |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
            root.each { | instance |
              instance.definition.set_attribute("dynamic_attributes", "_formatversion", "1.0")
              instance.definition.set_attribute("dynamic_attributes", "_has_movetool_behaviors", "1.0")
              instance.definition.set_attribute("dynamic_attributes", "_hasbehaviors", "1.0")
              instance.definition.set_attribute("dynamic_attributes", "_lengthunits", units)
              instance.definition.set_attribute("dynamic_attributes", "_name_label", "Name")
              instance.definition.set_attribute("dynamic_attributes", "_name", cmp_name)
              instance.set_attribute("dynamic_attributes", "_has_movetool_behaviors", "1.0")
              instance.set_attribute("dynamic_attributes", "_hasbehaviors", "1.0")
            }
          end
        }
        @@dialog.add_action_callback("set_attribute_def") { | action_context, key, value |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
            root.each { | instance |
              instance.definition.set_attribute("dynamic_attributes", key, value)
            }
          end
        }
        @@dialog.add_action_callback("set_attribute_inst") { | action_context, key, value |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
            root.each { | instance |
              instance.set_attribute("dynamic_attributes", key, value)
            }
          end
        }
        @@dialog.add_action_callback("del_attribute_def") { | action_context, key |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
            root.each { | instance |
              instance.definition.delete_attribute("dynamic_attributes", key)
            }
          end
        }
        @@dialog.add_action_callback("del_attribute_inst") { | action_context, key |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
            root.each { | instance |
              instance.delete_attribute("dynamic_attributes", key)
            }
          end
        }
        @@dialog.add_action_callback("delete_attributes_def") { | action_context |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
              root.each { | instance |
              instance.definition.delete_attribute("dynamic_attributes")
            }
          end
        }
        @@dialog.add_action_callback("delete_attributes_inst") { | action_context |
          root = Sketchup.active_model.selection
          if (!root.nil? && (root.count == 1))
              root.each { | instance |
              instance.delete_attribute("dynamic_attributes")
            }
          end
        }
        @@dialog.add_action_callback("show_info") { | action_context | self.show_definition_info }
        @@dialog.set_can_close {
          @@dialog = nil
          true
        }
        @@dialog.show
      end
    end

    def self.show_definition_info
      model = Sketchup.active_model
      root = model.selection
      if (!root.nil?)
        root.each { | instance |
          self.show_entity("", instance.definition, true)
          self.show_entity("", instance, false)
          puts
        }
      end
    end

    def self.show_entity(indent, entity, show_def)
      if (entity.typename == "Group")
        self.show_group(indent, entity, show_def);
      else
        if (entity.typename == "ComponentInstance")
          if (show_def)
            self.show_component_instance(indent, entity.definition, show_def);
          else
            self.show_component_instance(indent, entity, show_def);
          end;
        else
          if (entity.typename == "ComponentDefinition")
            self.show_component_definition(indent, entity, show_def);
          else
            return 1
          end
        end
      end
      return 0
    end

    def self.show_group(indent, group, show_def)
      if (group.typename == "Group")
        puts "#{indent}#{group.entityID} => #{group.typename}"
        if (!group.attribute_dictionaries.nil?)
          group.attribute_dictionaries.each { | dict |
            puts "#{indent}         #{dict.name} #{dict.count}"
            dict.each_pair { | key, value | puts "#{indent}           #{key} => #{value}" }
          }
        end
        #i = 0
        #group.entities.each { | e | i += self.show_entity("  " + indent, e, show_def) }
        #puts "#{indent} Contains #{i} faces and edges."
        return 0
      end
    end

    def self.show_component_instance(indent, instance, show_def)
      if (instance.typename == "ComponentInstance")
        puts "#{indent}#{instance.entityID} => #{instance.typename}"
        if (!instance.attribute_dictionaries.nil?)
          instance.attribute_dictionaries.each { | dict |
            puts "#{indent}         #{dict.name} #{dict.count}"
            dict.each_pair { | key, value | puts "#{indent}           #{key} => #{value}" }
          }
        end
        #i = 0
        #instance.definition.entities.each { | e | i += self.show_entity("  " + indent, e, show_def) }
        #puts "#{indent} Contains #{i} faces and edges."
      end
    end

    def self.show_component_definition(indent, definition, show_def)
      if (definition.typename == "ComponentDefinition")
        puts "#{indent}#{definition.entityID} => #{definition.typename} #{definition.name}"
        if (!definition.attribute_dictionaries.nil?)
          definition.attribute_dictionaries.each { | dict |
            puts "#{indent}         #{dict.name} #{dict.count}"
            dict.each_pair { | key, value | puts "#{indent}           #{key} => #{value}" }
          }
        end
        #i = 0
        #definition.entities.each { | e | i += self.show_entity("  " + indent, e, show_def) }
        #puts "#{indent} Contains #{i} faces and edges."
      end
    end
=begin
    def self.reload
      if (!@@dialog.nil?)
        @@dialog.close
      end
      original_verbose = $VERBOSE
      $VERBOSE = nil
      pattern = File.join(__dir__, '**/*.rb')
      Dir.glob(pattern).each { |file|
        # Cannot use `Sketchup.load` because its an alias for `Sketchup.require`.
        load file
      }.size
    ensure
      $VERBOSE = original_verbose
    end
=end
    unless file_loaded?(__FILE__)
      menu = UI.menu("Plugins") # .add_submenu("zestien3")
      menu.add_item('DC Editor') {
        self.add_attributes_html
      }
      file_loaded(__FILE__)
    end

  end # module DCEditor
end # module Zestien3
