extends Area2D

var launched = false
var velocity = Vector2.ZERO

var mass = 0.25

func _physics_process(delta):
	if launched:
		position += velocity * delta
		rotation = velocity.angle()
		
func launch(rot, speed):
	launched = true
	set_rotation(rot)
	velocity = Vector2(speed, 0).rotated(rot)
