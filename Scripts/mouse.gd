extends Area2D

@export var speed = 220 # How fast the player will move (pixels/sec).
@export var rotation_speed = 3
@export var qubit = 1 # The qubit value stored inside the mouse
@export var direction = Vector2.RIGHT # The initial direction of the mouse
var screen_size # Size of the game window.
var rotating = false
var target_angle
var current_quarter
	
func _ready():
	screen_size = get_viewport_rect().size


func _process(delta):
	var velocity = direction * speed
	if qubit == 1:
		$AnimatedSprite2D.play()
	elif qubit == 0:
		$AnimatedSprite2D.play_backwards()
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
	$AnimatedSprite2D.offset = Vector2(randf(), randf())


func _on_area_entered(area):
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
	position = (position / 50).round() * 50
	rotating = true

func add_degrees(angle1, angle2):
	return (angle1 + angle2 + 360) % 360 
