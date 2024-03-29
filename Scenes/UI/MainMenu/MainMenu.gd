extends Control

var MAX_LEVEL

onready var level_label = $LevelSelect/Label
var selected_level = 1

func _ready():
	MAX_LEVEL = Const.LEVEL_ORDER.size()
	if !Global.demo_popup_shown and OS.has_feature("standalone"):
		$DemoPopup.popup()
		$DemoPopup/OkDemoButton.grab_focus()
		Global.demo_popup_shown = true
	else:
		$Buttons/PlayButton.grab_focus()
	_update_level_label()

func _on_PlayButton_pressed():
	var status = LevelManager.start_level(Const.LEVEL_ORDER[selected_level-1])
	if status != OK:
		print(status)

func _on_QuitButton_pressed():
	get_tree().notification(MainLoop.NOTIFICATION_WM_QUIT_REQUEST)

func _update_level_label():
	level_label.text = "Level " + str(selected_level)

func _on_PrevLvlButton_pressed():
	selected_level -= 1
	if selected_level < 1:
		selected_level = MAX_LEVEL
	_update_level_label()

func _on_NextLvlButton_pressed():
	selected_level += 1
	if selected_level > MAX_LEVEL:
		selected_level = 1
	_update_level_label()

func _on_OkDemoButton_pressed():
	$DemoPopup.hide()
	$Buttons/PlayButton.grab_focus()

func _on_ControlsButton_pressed():
	$ControlsPopup.popup()
