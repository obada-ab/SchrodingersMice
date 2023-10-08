extends Node2D

var visible_timer = 0.6


func _ready():
	print(Global.frozen)
	if !Global.frozen:
		visible = false


func _process(delta):
	if visible:
		visible_timer -= delta
		if visible_timer <= 0:
			visible_timer = 0.6
			$Click.visible = !$Click.visible
