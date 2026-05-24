class_name Options

## Config file path.
const CONFIG_PATH := "user://options.cfg"
## Section of the config file under which all options are saved.
const OPTIONS_SECTION := "options"
## Node group containing all Option-derived nodes.
const OPTIONS_GROUP := &"options"
## Controls remap resource path.
const controls_remap_path := "user://controls.tres"

## Currently loaded options.
static var tree: SceneTree
static var options := { }
static var controls_remap := ControlsRemap.new()


## Set each option to its value read from the config file.
static func load_options() -> void:
	var config := ConfigFile.new()
	var err := config.load(CONFIG_PATH)
	if err == OK:
		for option_node in tree.get_nodes_in_group(OPTIONS_GROUP):
			var option := option_node as Option
			if config.has_section_key(OPTIONS_SECTION, option.key):
				option.set_option(
					config.get_value(OPTIONS_SECTION, option.key),
				)


## Load the controls remap resource from its resource file and apply it.
static func load_controls() -> void:
	if ResourceLoader.exists(controls_remap_path):
		controls_remap = load(controls_remap_path)
		controls_remap.apply_remap()
		ActionIcon.refresh_all()


## Save the currently loaded options to the config file.
static func save_options() -> bool:
	var config := ConfigFile.new()
	for option_node in tree.get_nodes_in_group(OPTIONS_GROUP):
		var option := option_node as Option
		config.set_value(OPTIONS_SECTION, option.key, option.get_option())
	return config.save(CONFIG_PATH)


## Apply the remapped controls to the resource and save it.
static func save_controls() -> void:
	controls_remap.create_remap()
	return ResourceSaver.save(controls_remap, controls_remap_path)


## Set each option to its default value.
static func restore_default_options() -> void:
	for option_node in tree.get_nodes_in_group(OPTIONS_GROUP):
		var option := option_node as Option
		option.set_option(option.get_default())


## Set controls to their default values.
static func restore_default_controls() -> void:
	controls_remap.restore_default_controls()
	ActionIcon.refresh_all()


## Set the options to their currently loaded values.
static func apply_options() -> void:
	for option_node in tree.get_nodes_in_group(OPTIONS_GROUP):
		var option := option_node as Option
		if option.key in options:
			option.set_option(options[option.key])
	ActionIcon.refresh_all()


## Perform initial options setup on game start. To be called by the root node of
## the startup scene to ensure that all Option nodes have entered the tree.
# (The Option nodes should be present in the startup scene.)
static func setup(scene_tree: SceneTree) -> void:
	assert(tree == null)
	assert(options.is_empty())
	tree = scene_tree
	# Apply defaults to ensure every option is set
	Options.restore_default_options()
	Options.restore_default_controls()
	# Load from config file, overwriting default options
	Options.load_options()
	Options.load_controls()
	# Re-save the config, including the default values for any unset options
	Options.save_options()
	Options.save_controls()
