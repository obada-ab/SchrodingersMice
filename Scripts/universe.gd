extends Node2D

var mice = 0
var exited_mice = 0

signal send_qubit
signal new_universe

func _ready():
	new_universe.connect(get_parent()._on_new_universe)


func _process(delta):
	pass


func _on_mouse_ready():
	mice += 1


func _on_mouse_split():
	new_universe.emit(self)


func _on_mouse_dead():
	mice -= 1


func _on_mouse_exited():
	exited_mice += 1


func set_qubit(val):
	send_qubit.emit(val)
