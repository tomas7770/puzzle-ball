extends Spatial

func _ready():
	$ParticleViewport/Control/CPUParticles2D.emitting = true

func _on_Timer_timeout():
	queue_free()
