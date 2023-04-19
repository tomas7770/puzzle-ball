extends Control

func _ready():
	$MenuButton.grab_focus()

func _on_MenuButton_pressed():
	var status = get_tree().change_scene("res://Scenes/UI/MainMenu/MainMenu.tscn")
	if status != OK:
		print("Return to menu: Error " + str(status))
