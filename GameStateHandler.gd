extends Node2D

var mice = 0
var exited_mice = 0

signal universe_value
signal new_universe

func _ready():
	new_universe.connect(get_parent()._on_new_universe)
	get_parent().universe_value.connect(_on_universe_value)


func _process(delta):
	pass


func _on_mouse_ready():
	mice += 1


func _on_mouse_split():
	new_universe.emit()


func _on_mouse_dead():
	mice -= 1


func _on_mouse_exited():
	exited_mice += 1


func _on_universe_value(val):
	universe_value.emit(val)
