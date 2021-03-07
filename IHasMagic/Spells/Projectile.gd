extends RigidBody

export var travel_speed = 50
export var lifetime = 1.5

var launch_origin
var death_timer

func _ready():
	launch_origin = global_transform.origin

func launch():
	death_timer = Timer.new()
	add_child(death_timer)
	death_timer.connect("timeout", self, "queue_free")
	death_timer.start(lifetime)
	
	set_as_toplevel(true)
	apply_central_impulse(-transform.basis.z * travel_speed)

func _on_Projectile_body_entered(body):
	if body is KinematicBody:
		var direction = body.transform.origin - launch_origin 
		body.move_and_slide(direction.normalized() * travel_speed * 2, Vector3.UP)
	queue_free()
