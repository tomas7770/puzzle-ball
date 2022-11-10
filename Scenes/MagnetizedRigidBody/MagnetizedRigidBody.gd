extends RigidBody

var magnet_force = 30

func apply_magnet_forces(dist_vector: Vector3, magnet_safe_distance):
	if dist_vector.length() > magnet_safe_distance:
		add_central_force(dist_vector.normalized()*magnet_force)
