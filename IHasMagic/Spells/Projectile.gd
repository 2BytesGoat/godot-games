extends RigidBody

export var travel_speed = 50
export var lifetime = 1.5

var death_timer

func launch():
	death_timer = Timer.new()
	add_child(death_timer)
	death_timer.connect("timeout", self, "queue_free")
	death_timer.start(lifetime)
	
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * travel_speed)