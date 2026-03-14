extends Node

const CONFIG_PATH := "user://save.cfg"
const STATS_SECTION := "stats"

var config := ConfigFile.new()
var stats: Array[Stat]

## Longest time survived, in milliseconds.
@onready var best_time := Stat.new(STATS_SECTION, "best_time", 0)
## Total number of deaths and restarts.
@onready var death_count := Stat.new(STATS_SECTION, "death_count", 0)

func _ready() -> void:
	config.load(CONFIG_PATH)
	SignalBus.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	death_count.set_value(death_count.get_value() + 1)
	var time_survived := Time.get_ticks_msec() - Globals.start_ticks
	if time_survived > best_time.get_value():
		best_time.set_value(time_survived)
	config.save(CONFIG_PATH)