extends Area2D

export var speed = 500

func _physics_process(delta):
	var velocity = Vector2(speed * delta, 0)
	position += velocity.rotated(rotation)
