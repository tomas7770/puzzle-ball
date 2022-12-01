extends RigidBody

var magnet_force = 30
var electricity_material = preload("res://Textures/ElectricityMaterial.tres")
var mesh_instance

func _ready():
	mesh_instance = get_node_or_null("MeshInstance")

func apply_anti_gravity():
	add_central_force(Vector3.UP*weight*gravity_scale)

func apply_magnet_forces(dist_vector: Vector3, magnet_safe_distance):
	var length = dist_vector.length()
	if length > magnet_safe_distance:
		var factor = min(pow(length/8.0, 2.0), 1.0)
		add_central_force(dist_vector.normalized()*magnet_force*factor)
	apply_anti_gravity()

func entered_magnet():
	if mesh_instance:
		mesh_instance.get_active_material(0).next_pass = electricity_material

func exited_magnet():
	if mesh_instance:
		mesh_instance.get_active_material(0).next_pass = null
