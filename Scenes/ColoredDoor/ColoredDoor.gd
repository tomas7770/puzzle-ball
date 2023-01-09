extends PhysicsBody

onready var sensor = $ColoredSensor
var collision_shape

func _ready():
	for child in get_children():
		if child is CollisionShape:
			collision_shape = child
			break
	if !(sensor.shape) and collision_shape:
		sensor.set_shape(collision_shape.shape)
	sensor.connect("activated", self, "_on_sensor_activated")

func _on_sensor_activated():
	queue_free()
