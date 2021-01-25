extends KinematicBody2D

var launched = false
var velocity = Vector2.ZERO

var mass = 0.25
var gravity_vec = Vector2(0, 1)
var gravity = 9.8

func _physics_process(delta):
	if launched:
		position += velocity * delta
		rotation = velocity.angle()
		
func launch(initial_velocity: Vector2):
	launched = true
	velocity = initial_velocity
