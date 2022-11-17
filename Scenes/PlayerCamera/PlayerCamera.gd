extends Camera

var player
var offset = Vector3(0, 1, 12)

func set_player(new_player):
	player = new_player

func _process(_delta):
	if !player:
		return
	global_translation = player.get_global_transform_interpolated().origin + offset
