extends Node

var body

var magnet_force = 30
var electricity_material = preload("res://textures/ElectricityMaterial.tres")
var mesh_instance

func _ready():
	body = get_parent()
	if !(body is RigidBody):
		return
	mesh_instance = body.get_node_or_null("MeshInstance")

func _apply_anti_gravity():
	if !body:
		return
	body.add_central_force(Vector3.UP*body.weight*body.gravity_scale)

func apply_magnet_forces(dist_vector: Vector3, magnet_safe_distance):
	if !body:
		return
	var length = dist_vector.length()
	if length > magnet_safe_distance:
		var factor = min(pow(length/8.0, 2.0), 1.0)
		body.add_central_force(dist_vector.normalized()*magnet_force*factor)
	_apply_anti_gravity()

func entered_magnet():
	if !mesh_instance:
		return
	if mesh_instance:
		var material = mesh_instance.get_active_material(0)
		if material.next_pass:
			material.next_pass.next_pass = electricity_material
		else:
			material.next_pass = electricity_material

func exited_magnet():
	if !mesh_instance:
		return
	if mesh_instance:
		var material = mesh_instance.get_active_material(0)
		if material.next_pass != electricity_material:
			material.next_pass.next_pass = null
		else:
			material.next_pass = null
