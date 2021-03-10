extends Area

export var damage = 1
var knockback_vector = Vector3.ZERO
var knockback_power = 20
onready var projectile = get_parent()

func _process(_delta):
	knockback_vector = projectile.global_transform.origin - projectile.launch_origin
	knockback_vector = knockback_vector.normalized()
