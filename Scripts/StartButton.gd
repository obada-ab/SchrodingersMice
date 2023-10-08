extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_input_event(viewport, event, shape_idx):
	if !Global.frozen && event is InputEventMouseButton && \
		event.button_index == MOUSE_BUTTON_LEFT && \
		event.pressed:
		Global.paused = false


func _on_mouse_entered():
	if !Global.frozen && Global.paused:
		self.modulate.a = 0.7


func _on_mouse_exited():
	if !Global.frozen && Global.paused:
		self.modulate.a = 1
