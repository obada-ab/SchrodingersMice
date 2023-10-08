extends Area2D

var clicked = false
var original_position
var original_scale
@export var toggled: bool = false

var colliding_areas = []

@export var connected_blocks : Array[Node] = []

func press():
	$AnimatedSprite2D.frame = 1
	collision_layer = 0
	for connected_block in connected_blocks:
		connected_block.enable()

func _ready():
	original_position = global_position
	original_scale = global_scale


func _process(delta):
	if clicked:
		global_position = get_viewport().get_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && \
		event.button_index == MOUSE_BUTTON_LEFT && \
		event.pressed && Global.paused && !Global.frozen && \
		get_parent().name == "HUD":
		clicked = true


func _input(event):
	if clicked && event is InputEventMouseButton && \
		event.button_index == MOUSE_BUTTON_LEFT && \
		!event.pressed:
		clicked = false
		if len(colliding_areas) == 0:
			global_scale = original_scale
			global_position = original_position
			get_parent().remove_child(self)
			Global.current_scene.get_node("HUD").add_child(self)
		else:
			var min_distance = INF
			var target_area
			for area in colliding_areas:
				var distance = (global_position - area.global_position).length()
				if distance < min_distance:
					min_distance = distance
					target_area = area
			
			get_parent().remove_child(self)
			target_area.get_parent().add_sibling(self)
			
			scale = target_area.scale
			position = target_area.position
			
			target_area.queue_free()


func _on_area_entered(area):
	colliding_areas.push_back(area)


func _on_area_exited(area):
	colliding_areas.pop_at(colliding_areas.find(area))


func enable():
	$AnimatedSprite2D.frame = 1
	toggled = false
