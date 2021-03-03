extends KinematicBody

export var MAX_SPEED = 75
export var ACCELERATION = 500
export var FRICTION = 500

export(NodePath) onready var animation_tree = get_node(animation_tree)
onready var animation_playback = animation_tree.get("parameters/playback")

var gravity_push = 9.8
var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO

var blend_position = Vector2.ZERO

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	#var root_motion: Transform = animation_tree.get_root_motion_transform()
	#var v = root_motion.origin / delta
	move_state(delta)
	
	
func move_state(delta):
	input_vector.x = Input.get_action_strength("move_left") - \
				Input.get_action_strength("move_right")
	input_vector.z = Input.get_action_strength("move_forward") - \
				Input.get_action_strength("move_backward")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector3.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, 
						ACCELERATION * delta)
		blend_position = Vector2(input_vector.x, input_vector.z)
		if blend_position.y >= 0:
			animation_tree.set("parameters/WalkingForward/blend_position", blend_position)
			animation_playback.travel('WalkingForward')
		else:
			animation_tree.set("parameters/WalkingBackward/blend_position", blend_position)
			animation_playback.travel('WalkingBackward')
	else:
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
		animation_playback.travel('Idle')

	velocity.y = 0 if is_on_floor() else velocity.y - 9.8 

	move_and_slide(velocity, Vector3.UP)
