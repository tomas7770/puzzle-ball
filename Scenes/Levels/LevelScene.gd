extends Spatial

onready var player_camera = $PlayerCamera
onready var player_ball = $PlayerBall

func _ready():
	player_camera.set_player(player_ball)
