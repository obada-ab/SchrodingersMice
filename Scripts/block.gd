extends Area2D

var clicked = false
var original_position

var colliding_areas = []

func _ready():
	original_position = global_position


func _process(delta):
	if clicked:
		global_position = get_viewport().get_mouse_position()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && \
		event.button_index == MOUSE_BUTTON_LEFT && \
		event.pressed && Global.paused:
		clicked = true


func _input(event):
	if clicked && event is InputEventMouseButton && \
		event.button_index == MOUSE_BUTTON_LEFT && \
		!event.pressed:
		clicked = false
		if len(colliding_areas) == 0:
			global_position = original_position
		else:
			var min_distance = INF
			var target_area
			for area in colliding_areas:
				var distance = (global_position - area.global_position).length()
				if distance < min_distance:
					min_distance = distance
					target_area = area
			scale = target_area.scale
			global_position = target_area.global_position


func _on_area_entered(area):
	colliding_areas.push_back(area)


func _on_area_exited(area):
	colliding_areas.pop_at(colliding_areas.find(area))
