extends KinematicBody2D

var speed = 150
var spawn_rate = 0.65

var positioning_node: PathFollow2D

onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	if positioning_node:
		positioning_node.offset += speed * delta
		animationState.travel('Move')
	else:
		animationState.travel('Idle')
