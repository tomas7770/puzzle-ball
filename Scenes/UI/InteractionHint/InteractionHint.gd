extends Control

onready var button_texture = $HBoxContainer/ButtonTexture
onready var label = $HBoxContainer/ButtonTexture/Label
onready var name_label = $HBoxContainer/NameTexture/Label

func _ready():
	var events = InputMap.get_action_list("plr1_interact")
	for event in events:
		if event is InputEventKey:
			label.text = OS.get_scancode_string(event.scancode)

func set_interaction_name(interaction_name):
	if interaction_name:
		name_label.text = interaction_name

func hide_button():
	button_texture.visible = false
