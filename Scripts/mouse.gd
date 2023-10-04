extends Area2D

@export var speed = 220 # How fast the player will move (pixels/sec).
@export var rotation_speed = 3
@export var qubit = 1 # The qubit value stored inside the mouse
@export var direction = Vector2.RIGHT # The initial direction of the mouse
var rotating = false
var target_angle
var current_quarter
var shake = 1
var mice = []
var splitting = false


signal mouse_ready
signal mouse_exited_level
signal mouse_split
signal mouse_dead
	
func _ready():
	mouse_ready.connect(get_parent()._on_mouse_ready)
	mouse_exited_level.connect(get_parent()._on_mouse_exited)
	mouse_split.connect(get_parent()._on_mouse_split)
	mouse_dead.connect(get_parent()._on_mouse_dead)
	get_parent().next_universe.connect(_on_next_universe)
	get_parent().new_universe.connect(_on_new_universe)
	mouse_ready.emit()


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
		splitting = true
		mouse_split.emit()


func next_mouse():
	var next_mouse = mice.pop_back()
	next_mouse.mice = mice.duplicate()
	call_deferred("add_sibling", next_mouse)
	mouse_dead.emit()
	queue_free()


func add_degrees(angle1, angle2):
	return (angle1 + angle2 + 360) % 360 


func _on_hadamard_detector_area_entered(area):
	qubit = 2
	shake = 2.5


func _on_exit_detector_area_exited(area):
	mouse_exited_level.emit()


func _on_next_universe():
	next_mouse()

func _on_new_universe():
	for i in range(2):
		var new_mouse = duplicate()
		new_mouse.position = position
		new_mouse.qubit = i if splitting else qubit
		new_mouse.shake = 1 if splitting else shake
		mice.push_back(new_mouse)
	next_mouse()
