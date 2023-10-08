extends Node2D


func _ready():
	print(Global.frozen)
	if !Global.frozen:
		visible = false
