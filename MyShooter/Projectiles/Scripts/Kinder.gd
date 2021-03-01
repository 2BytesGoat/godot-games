extends Bullet

onready var decal = preload("res://Projectiles/EggYolk.tscn")

func _on_RigidBody_body_entered(body):
	var new_decal = decal.instance()
	body.add_child(new_decal)
	new_decal.global_transform.origin = self.transform.origin
	
