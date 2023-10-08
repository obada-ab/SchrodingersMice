extends RichTextLabel


func _ready():
	text = "LVL\n " + str(Global.current_level + 1)
