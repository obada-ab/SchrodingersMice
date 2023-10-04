extends Node2D

var universe = 1
var total_universe = 1
var mice = 0
var exited_mice = 0

signal next_universe
signal new_universe

func _ready():
	$UniverseLabel.text = str(universe) + "/" + str(total_universe)


func _process(delta):
	pass


func _on_mouse_ready():
	mice += 1


func _on_mouse_split():
	total_universe += 1
	$UniverseLabel.text = str(universe) + "/" + str(total_universe)
	new_universe.emit()


func _on_mouse_dead():
	mice -= 1


func _on_mouse_exited():
	exited_mice += 1
	if exited_mice == mice:
		universe += 1
		if universe > total_universe:
			$UniverseLabel.text = "WIN"
			return
		next_universe.emit()
		exited_mice = 0
		$UniverseLabel.text = str(universe) + "/" + str(total_universe)
