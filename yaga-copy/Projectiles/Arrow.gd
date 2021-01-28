extends Area2D

var launched = false
var collided = false
var velocity = Vector2.ZERO

var mass = 0.25

func _physics_process(delta):
	if launched and not collided:
		position += velocity * delta
		rotation = velocity.angle()
		collided = len(get_overlapping_bodies()) > 0
	if collided: # make arrows stick
		get_parent().remove_child(self)
		
func launch(rot, speed):
	launched = true
	set_rotation(rot)
	velocity = Vector2(speed, 0).rotated(rot)
