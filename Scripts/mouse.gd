extends Area2D

@export var speed = 220 # How fast the player will move (pixels/sec).
@export var rotation_speed = 3
@export var qubit = 1 # The qubit value stored inside the mouse
@export var direction = Vector2.RIGHT # The initial direction of the mouse
var screen_size # Size of the game window.
var rotating = false
var target_angle
var current_quarter
var shake = 1
	
func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	var velocity = direction * speed
	if qubit == 1:
		$AnimatedSprite2D.play()
	elif qubit == 0:
		$AnimatedSprite2D.play_backwards()
	else:
		$AnimatedSprite2D.stop()
	if rotating:
		var current_angle = int(round($AnimatedSprite2D.rotation_degrees))
		if qubit == 1:
			$AnimatedSprite2D.rotation_degrees = add_degrees(current_angle, -rotation_speed)
		elif qubit == 0:
			$AnimatedSprite2D.rotation_degrees = add_degrees(current_angle, rotation_speed)
		if int(round($AnimatedSprite2D.rotation_degrees)) / 90 != current_quarter:
			$AnimatedSprite2D.rotation_degrees = target_angle
			rotating = false
	else:
		position += velocity * delta
	$AnimatedSprite2D.offset = shake * Vector2(randf(), randf())


func _on_area_entered(area):
	position = (position / 50).round() * 50
	rotating = true
	if qubit == 1:
		var current_angle = int(round($AnimatedSprite2D.rotation_degrees))
		direction = direction.rotated(-PI/2)
		target_angle = add_degrees(current_angle, -90)
		current_quarter = add_degrees(current_angle, -1) / 90
	elif qubit == 0:
		var current_angle = int(round($AnimatedSprite2D.rotation_degrees))
		direction = direction.rotated(PI/2)
		target_angle = add_degrees(current_angle, 90)
		current_quarter = add_degrees(current_angle, 1) / 90
	else:
		for i in range(2):
			var new_mouse = duplicate()
			new_mouse.position = position
			new_mouse.qubit = i
			new_mouse.modulate.a = 0.8
			new_mouse.shake = 1
			add_sibling(new_mouse)
		queue_free()

func add_degrees(angle1, angle2):
	return (angle1 + angle2 + 360) % 360 


func _on_hadamard_detector_area_entered(area):
	qubit = 2
	shake = 2.5
