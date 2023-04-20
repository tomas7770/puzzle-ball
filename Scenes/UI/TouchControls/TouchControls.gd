extends Node

# The radius inside which the analog stick responds
const ANALOG_STICK_RADIUS = 80
# The radius on which the full strength of the analog stick action is reached
const ANALOG_STICK_ACT_RADIUS = 64

const ANALOG_STICK_CENTER = Vector2(32, 32)

onready var viewport = $Viewport
onready var viewport_rect = $ViewportRect

onready var stick_control = $Viewport/StickControl
onready var stick_center = $Viewport/StickControl/StickCenter

var analog_pressed = false
var analog_finger_index

func _ready():
	# Touch controls' physical size should be fixed across screens,
	# unlike the rest of the UI, which scales
	_update_viewport_size()
	# warning-ignore:return_value_discarded
	get_tree().root.connect("size_changed", self, "_update_viewport_size")

func _update_viewport_size():
	var window_size = OS.get_window_size()
	var screen_scale
	
	var os_name = OS.get_name()
	if os_name == "OSX" or os_name == "iOS":
		screen_scale = OS.get_screen_scale()
	else:
		var dpi = OS.get_screen_dpi()
		if os_name == "Android":
			screen_scale = dpi/160.0
		else:
			screen_scale = dpi/96.0
	
	viewport.size = window_size/screen_scale

func _input(event):
	var orig_position = null
	if event.get("position"):
		orig_position = event.position
		event.position = _map_position_to_viewport(event.position)
	
	# Analog stick
	if event is InputEventScreenTouch:
		if event.pressed:
			if !analog_pressed and _position_is_in_stick(event.position):
				# Stick pressed
				analog_finger_index = event.index
				analog_pressed = true
				stick_center.rect_position = _get_relative_stick_pos(event.position)
				Input.action_press("plr1_analog", _get_stick_strength(event.position))
		elif event.index == analog_finger_index:
			# Stick released
			analog_pressed = false
			stick_center.rect_position = ANALOG_STICK_CENTER
			Input.action_release("plr1_analog")
	elif event is InputEventScreenDrag and analog_pressed and event.index == analog_finger_index:
		# Stick dragged
		stick_center.rect_position = _get_relative_stick_pos(event.position)
		Input.action_press("plr1_analog", _get_stick_strength(event.position))
	
	viewport.input(event)
	# Restore normal position to avoid affecting other UIs
	if orig_position:
		event.position = orig_position

func _map_position_to_viewport(position):
	var base_size = viewport_rect.rect_size
	var viewport_size = viewport.size
	return Vector2(viewport_size.x*position.x/base_size.x, viewport_size.y*position.y/base_size.y)

func _get_stick_center_pos():
	return stick_control.rect_position + stick_control.rect_size/2

func _position_is_in_stick(input_pos):
	return (input_pos - _get_stick_center_pos()).length() <= ANALOG_STICK_RADIUS

func _get_relative_stick_pos(input_pos):
	return (input_pos - _get_stick_center_pos()).limit_length(ANALOG_STICK_ACT_RADIUS) \
		+ ANALOG_STICK_CENTER

func _get_stick_strength(input_pos):
	var input_vector = (input_pos - _get_stick_center_pos()).limit_length(ANALOG_STICK_ACT_RADIUS)
	return input_vector.x / ANALOG_STICK_ACT_RADIUS
