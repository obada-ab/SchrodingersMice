extends Node

var split_count = 0
@export var foregrounds: Array[Node] = []
@onready var universe_scene = preload("res://Scenes/universe.tscn")
var locations = []
var mouse_properties = [
	"direction",
	"splitting",
	"rotating",
	"target_angle",
	"current_quarter"
]
var fading_time = 3
var total_universes = 1
var finished_universes = 0

func _ready():
	for node in foregrounds:
		locations.push_back(node.position)
		print(node.position)


func _process(delta):
	pass


func _on_new_universe(universe):
	total_universes += 1
	if split_count >= len(locations):
		return
	var new_universe = universe_scene.instantiate()
	new_universe.scale = universe.scale
	for node in universe.get_children():
		var new_node = node.duplicate()
		for property in mouse_properties:
			var value = node.get(property)
			if value != null:
				new_node.set(property, value)
		new_universe.add_child(new_node)
	new_universe.position = locations[split_count]
	foregrounds[split_count].fade(fading_time)
	call_deferred("add_child", new_universe)
	universe.set_qubit(0)
	new_universe.call_deferred("set_qubit", 1)
	split_count += 1


func _on_universe_done():
	finished_universes += 1
	if finished_universes == total_universes:
		Global._next_level()
