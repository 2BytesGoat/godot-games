extends RigidBody
class_name Bullet

export var lifetime: float = 2

func fire(muzzle_velocity: float) -> void:
	var death_timer = Timer.new()
	add_child(death_timer)
	death_timer.connect("timeout", self, "queue_free")
	death_timer.start(lifetime)
	
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * muzzle_velocity)


