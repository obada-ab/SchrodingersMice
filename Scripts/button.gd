extends Area2D

@export var connected_blocks : Array[Node] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func press():
	$AnimatedSprite2D.frame = 1
	collision_layer = 0
	for connected_block in connected_blocks:
		connected_block.enable()
