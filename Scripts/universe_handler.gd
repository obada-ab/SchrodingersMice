extends Node

var split_count = 0
@onready var foregrounds = [$Foreground, $Foreground2, $Foreground3]
@onready var universe_scene = preload("res://Scenes/universe.tscn")
var locations = []
var mouse_properties = [
	"direction",
	"splitting",
	"rotating",
	"target_angle",
	"current_quarter"
]

func _ready():
	for node in foregrounds:
		locations.push_back(node.position)
		print(node.position)


func _process(delta):
	pass


func _on_new_universe(universe):
	print("NEW UNIVERSE!!!!")
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
	foregrounds[split_count].visible = false
	add_child(new_universe)
	universe.set_qubit(0)
	new_universe.set_qubit(1)
	split_count += 1
