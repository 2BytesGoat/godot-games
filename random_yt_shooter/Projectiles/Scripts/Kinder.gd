extends Bullet

var starting_position: Vector3 = Vector3.ZERO
onready var decal = preload("res://Projectiles/EggYolk.tscn")

func _ready():
	starting_position = global_transform.origin

func _on_RigidBody_body_entered(body):
	if body.is_in_group("Enemy"):
		body.health -= damage
