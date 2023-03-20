extends Control

onready var label = $ButtonTexture/Label

func _ready():
	var events = InputMap.get_action_list("plr1_interact")
	for event in events:
		if event is InputEventKey:
			label.text = OS.get_scancode_string(event.scancode)
