extends KinematicBody2D

const FRICTION = 200

var health = 3
var knockback = Vector2.ZERO

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)

func _on_HurtBox_area_entered(area):
	knockback = area.knockback_vector * 150
	health = health - area.damage
	if health <= 0:
		queue_free()
