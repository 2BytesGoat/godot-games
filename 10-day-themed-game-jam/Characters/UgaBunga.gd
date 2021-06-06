extends KinematicBody2D

var speed = 150
var spawn_rate = 0.65

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	if get_parent().is_class("PathFollow2D"):
		get_parent().offset += speed * delta
		animationState.travel("Move")
	else:
		animationState.travel("Idle")
