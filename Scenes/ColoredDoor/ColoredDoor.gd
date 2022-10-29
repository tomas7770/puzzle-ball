extends PhysicsBody

onready var sensor = $ColoredSensor

func _ready():
	sensor.connect("activated", self, "_on_sensor_activated")

func _on_sensor_activated():
	queue_free()
