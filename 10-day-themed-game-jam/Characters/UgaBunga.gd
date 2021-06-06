extends KinematicBody2D

var speed = 150
var spawn_rate = 0.5

func _physics_process(delta):
	if get_parent().is_class("PathFollow2D"):
		get_parent().offset += speed * delta
