extends Area2D

@export var speed = 270 # How fast the player will move (pixels/sec).
@export var rotation_speed = 5
@export var qubit = 1 # The qubit value stored inside the mouse
@export var direction = Vector2.RIGHT # The initial direction of the mouse
var rotating = false
var target_angle
var current_quarter
var shake = 1
var mice = []
var splitting = false
var pause_timer = 0
var blinking = false
var entangled_mouse
var qubit_visible_timer = 0


signal mouse_ready
signal mouse_exited_level
signal mouse_split
signal mouse_dead
	
func _ready():
	mouse_ready.connect(get_parent()._on_mouse_ready)
	mouse_exited_level.connect(get_parent()._on_mouse_exited)
	mouse_split.connect(get_parent()._on_mouse_split)
	mouse_dead.connect(get_parent()._on_mouse_dead)
	get_parent().send_qubit.connect(_on_send_qubit)
	position = (position / 50).round() * 50
	mouse_ready.emit()
	$Qubit.visible = false


func _process(delta):
	if qubit_visible_timer > 0:
		qubit_visible_timer = max(0, qubit_visible_timer - delta)
		if qubit_visible_timer == 0:
			$Qubit.visible = false
	if pause_timer > 0:
		pause_timer = max(0, pause_timer - delta)
		if blinking:
			visible = int(pause_timer * 10) % 2
		return
	if !visible:
		visible = true
	if blinking:
		blinking = false
	if splitting:
		splitting = false
	var velocity = direction * speed
	if qubit == 1:
		$AnimatedSprite2D.play()
	elif qubit == 0:
		$AnimatedSprite2D.play_backwards()
	else:
		$AnimatedSprite2D.stop()
	if Global.paused:
		return
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
	if Global.paused:
		return
	if area.name.begins_with("Button"):
		return
	if area.name.begins_with("Toggled") && area.toggled:
		return
	position = (position / 50).round() * 50
	if rotating or splitting:
		return
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
	else :
		split()
		if entangled_mouse:
			entangled_mouse.split()
		mouse_split.emit()


func split():
	splitting = true
	rotating = false
	shake = 1


func enter_superposition():
	qubit = 2
	shake = 2.5


func add_degrees(angle1, angle2):
	return (angle1 + angle2 + 360) % 360 


func _on_hadamard_detector_area_entered(area):
	if Global.paused:
		return
	area.deactivate()
	enter_superposition()
	_show_qubit()


func _on_exit_detector_area_exited(area):
	pass
	#mouse_exited_level.emit()
	#queue_free()


func _on_send_qubit(val):
	pause(2)
	if splitting:
		blinking = true
		qubit = val
		shake = 1
		_show_qubit()
	splitting = false
	


func pause(pause_duration):
	pause_timer = pause_duration


func _on_entanglement_detector_area_entered(area):
	if Global.paused:
		return
	if area.entangled_mouse:
		area.deactivate()
		entangled_mouse = area.entangled_mouse
		entangled_mouse.entangled_mouse = self
		enter_superposition()
		entangled_mouse.enter_superposition()
		_show_qubit()
		entangled_mouse._show_qubit()
	else:
		area.entangled_mouse = self


func _on_entanglement_detector_area_exited(area):
	if Global.paused:
		return
	if area.entangled_mouse && area.entangled_mouse == self:
		area.entangled_mouse = null


func _on_button_detector_area_entered(area):
	if Global.paused:
		return
	if area.name.begins_with("Button"):
		area.press()


func _on_exit_detector_area_entered(area):
	mouse_exited_level.emit()
	queue_free()


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseMotion:
		_show_qubit()

func _show_qubit():
	$Qubit.frame = qubit
	$Qubit.visible = true
	qubit_visible_timer = 1.5
