extends KinematicBody2D

var velocity = Vector2.ZERO

func _ready():
	set_physics_process(false)

func _physics_process(delta):
	var collision = move_and_collide(velocity)
	if collision != null:
		_on_inpact(collision.normal)
	
func _on_inpact(normal: Vector2):
	set_physics_process(false)
	$CollisionShape2D.disabled = true
	
func launch(rot, speed):
	# Transfer object from player to scene
	var temp = global_transform
	var scene = get_tree().current_scene.get_child(1)
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	# Set position and rotation based on shooting origin
	set_rotation(rot)
	velocity = Vector2(speed, 0).rotated(rot)
	set_physics_process(true)
