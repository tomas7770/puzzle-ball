extends PhysicsBody

onready var sensor = $ColoredSensor
onready var collision_shape = $CollisionShape
onready var mesh_instance = $MeshInstance
onready var animation_player = $AnimationPlayer
onready var destroy_timer = $DestroyTimer
export (float) var door_opacity setget _set_door_opacity

var destroyed = false

func _ready():
	set_meta("door", true)
	if !(sensor.shape):
		sensor.set_shape(collision_shape.shape)
	sensor.connect("activated", self, "_on_sensor_activated")
	# Make the mesh and material unique so that each door can be faded out individually
	mesh_instance.mesh = mesh_instance.mesh.duplicate()
	mesh_instance.mesh.surface_set_material(0, mesh_instance.mesh.surface_get_material(0).duplicate())
	var material = mesh_instance.mesh.surface_get_material(0)
	if material.next_pass:
		material.next_pass = material.next_pass.duplicate()

func _on_sensor_activated():
	if destroyed:
		return
	destroyed = true
	collision_shape.queue_free()
	if mesh_instance:
		var material = mesh_instance.mesh.surface_get_material(0)
		if material.get("flags_transparent") != null:
			material.flags_transparent = true
	animation_player.play("DoorDestroy")
	destroy_timer.start()

func _on_DestroyTimer_timeout():
	queue_free()

func _set_door_opacity(opacity):
	if mesh_instance:
		var material = mesh_instance.mesh.surface_get_material(0)
		if material.get("albedo_color") != null:
			mesh_instance.mesh.surface_get_material(0).albedo_color.a = opacity

func is_same_color(color):
	return sensor.get_sensor_color_code() == color
