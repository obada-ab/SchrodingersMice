extends Node

var current_scene = null
var current_level = null
var paused = true
var frozen = false

const level_text = [
	[
		"Welcome. this is your first day at Quantum Cheese labs, isn't it?",
		"My name is RatGPT, I will help you get familiar with your job",
		"As a quantum mice researcher, you will study their behaviour-",
		"and try to help them escape these pre-built mazes, understood?",
		"Quantum mice move forward, and when they hit a block or wall-",
		"they will either rotate clock-wise or counter clock-wise",
		"you can check the behaviour of a mouse by hovering over it, give it a try",
		"Try placing the block below somewhere to help the mouse escape",
		"Click the start button to begin, and retry if you're stuck. Good Luck!",
	],
	[
		"Well done! Now let's see if you can help both of these mice escape",
		"Notice that each of these mice has a different spinning direction",
		"buttons toggle a hidden blocks of the same color and allows them",
		"to materialize. Use this to your advantage.",
	],
	[
		"Nice job so far, let us now explore some quantum properties",
		"These aren't called quantum mice for no reason, after all",
		"This here is a hadamard block. When a mouse touches it,-",
		"it enters a \"superposition\" state, rotating in both directions-",
		"at the same time. After hitting a wall or a block, the rotation-",
		"state will collapse into a single value. The second monitor-",
		"will help you observe all possibilities. Try helping the",
		"quantum mouse escape regardless of it's collapsed state.",
	],
	[
		"You're starting to become good at this, a fast learner indeed",
		"You can think of the mouse's collapse moment as a branching point in time",
		"Essentially creating two universes, one for each possibility. Of course-",
		"this is all theoretical and what you see on the monitors is a simulation.",
		"Now, can you help this mouse escape in both simulated universes?",
	],
	[],
	[
		"Let's explore another important property of quantum mice",
		"This here is an entanglement block, two mice need to touch it simultaneously-",
		"to activate it. These two mice will become \"entangled\": If the value of one-",
		"entangled mouse collapses, the value of the paired mouse collapses instantly-",
		"to the same value regardless of the distance between them",
		"Try running the simulation for yourself, and find a way to save the mice",
	],
	[],
	[],
	[]
]
var level_text_counter = 0


func _check_level():
	if current_scene.name.begins_with("Level"):
		current_level = int(current_scene.name.substr(5)) - 1
		if len(level_text[current_level]) > 0:
			frozen = true
			set_text()


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	_check_level()
	var bgm = preload("res://Scenes/bgm.tscn").instantiate()
	root.call_deferred("add_child", bgm)
	bgm.call_deferred("play")


func goto_scene(path, check_text):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, check_text)


func _deferred_goto_scene(path, check_text):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instantiate()
	if check_text:
		_check_level()

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene


func _reset_scene():
	paused = true
	frozen = false
	goto_scene(current_scene.scene_file_path, false)
	


func _next_level():
	paused = true
	current_level += 1
	goto_scene("res://Scenes/level_" + str(current_level + 1) + ".tscn", true)


func _input(event):
	if frozen && event is InputEventMouseButton && event.pressed && \
		event.button_index == MOUSE_BUTTON_LEFT:
		level_text_counter += 1
		if level_text_counter < len(level_text[current_level]):
			set_text()
		else:
			frozen = false
			current_scene.get_node("TextBox").visible = false
			level_text_counter = 0


func set_text():
	current_scene.get_node("TextBox").get_node("RichTextLabel").text = level_text[current_level][level_text_counter]
