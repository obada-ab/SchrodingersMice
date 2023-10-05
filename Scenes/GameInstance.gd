extends Node2D

signal universe_value
var split_count = 0

func _ready():
	pass


func _process(delta):
	pass


func _on_new_universe():
	split_count += 1
	if split_count == 1:
		var new_universe = duplicate()
		new_universe.scale = Vector2(0.35, 0.35)
		new_universe.split_count = split_count
		scale = Vector2(0.35, 0.35)
		translate(Vector2(get_viewport_rect().size.x * 0.55, 50))
		new_universe.translate(Vector2(get_viewport_rect().size.x * 0.05, 50))
		add_sibling(new_universe)
		universe_value.emit(0)
	else:
		var new_universe = duplicate()
		new_universe.translate(Vector2(0, get_viewport_rect().size.y * 0.5))
		add_sibling(new_universe)
		universe_value.emit(0)
	
