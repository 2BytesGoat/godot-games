extends KinematicBody

var health = 200

func _ready():
	pass # Replace with function body.

func _process(delta):
	if health <= 0:
		queue_free()
