extends Node

## Config file path.
const CONFIG_PATH := "user://options.cfg"
## Section of the config file under which all options are saved.
const OPTIONS_SECTION := "options"
## Node group containing all Option-derived nodes.
const OPTIONS_GROUP := &"options"
## Controls remap resource path.
const controls_remap_path := "user://controls.tres"

## Currently loaded options.
var options := {}
var controls_remap := ControlsRemap.new()


## Set each option to its value read from the config file.
func load_config() -> void:
	var config := ConfigFile.new()
	var err := config.load(CONFIG_PATH)
	if err == OK:
		for option_node in get_tree().get_nodes_in_group(OPTIONS_GROUP):
			var option := option_node as Option
			if config.has_section_key(OPTIONS_SECTION, option.key):
				option.set_option(
					config.get_value(OPTIONS_SECTION, option.key)
				)
	if ResourceLoader.exists(controls_remap_path):
		controls_remap = load(controls_remap_path)
		controls_remap.apply_remap()
		ActionIcon.refresh_all()


## Save the currently loaded options to the config file.
func save_config() -> bool:
	var config := ConfigFile.new()
	for option_node in get_tree().get_nodes_in_group(OPTIONS_GROUP):
		var option := option_node as Option
		config.set_value(OPTIONS_SECTION, option.key, option.get_option())
	controls_remap.create_remap()
	var controls_save_result := ResourceSaver.save(controls_remap, controls_remap_path)
	var config_save_result := config.save(CONFIG_PATH)
	return controls_save_result == OK and config_save_result == OK


## Set each option to its default value.
func apply_defaults() -> void:
	for option_node in get_tree().get_nodes_in_group(OPTIONS_GROUP):
		var option := option_node as Option
		option.set_option(option.get_default())
	controls_remap.restore_default_controls()
	ActionIcon.refresh_all()


## Set the options to their currently loaded values.
func apply_options() -> void:
	for option_node in get_tree().get_nodes_in_group(OPTIONS_GROUP):
		var option := option_node as Option
		if option.key in options:
			option.set_option(options[option.key])
	ActionIcon.refresh_all()


## Perform initial options setup on game start. To be called by the root node of
## the startup scene to ensure that all Option nodes have entered the tree.
# (The Option nodes should be present in the startup scene.)
func setup() -> void:
	if options.is_empty():
		# Apply defaults to ensure every option is set
		Options.apply_defaults()
		# Load from config file, overwriting default options
		Options.load_config()
		# Re-save the config, including the default values for any unset options
		Options.save_config()