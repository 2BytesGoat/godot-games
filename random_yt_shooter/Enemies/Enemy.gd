extends KinematicBody

var health = 20

func _ready():
	pass # Replace with function body.

func _process(_delta):
	if health == 0:
		queue_free()
