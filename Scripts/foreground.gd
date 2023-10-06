extends Node2D

var fading = false
var fading_duration
var fading_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	for node in get_children():
		node.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if fading:
		if fading_timer >= fading_duration:
			queue_free()
		fading_timer += delta
		modulate.a = 1 - ease(fading_timer / fading_duration, 0.2)

func fade(duration):
	fading_duration = duration
	fading = true
