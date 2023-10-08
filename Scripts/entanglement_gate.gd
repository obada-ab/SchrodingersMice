extends Area2D

var entangled_mouse
var active = true

func _ready():
	pass # Replace with function body.


func _process(delta):
	pass


func deactivate():
	active = false
	modulate.a /= 2
	collision_layer = 0
