extends RigidBody

var acceleration = 20

func _physics_process(_delta):
	if Input.is_action_pressed("plr1_left"):
		add_central_force(Vector3(-acceleration, 0, 0))
	elif Input.is_action_pressed("plr1_right"):
		add_central_force(Vector3(acceleration, 0, 0))
