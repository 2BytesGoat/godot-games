extends KinematicBody

export var MAX_WALK_SPEED = 2
export var MAX_RUN_SPEED = 5
export var ACCELERATION = 30
export var FRICTION = 500

export(NodePath) onready var animation_tree = get_node(animation_tree)
onready var animation_playback = animation_tree.get("parameters/playback")

var gravity_push = 9.8
var velocity = Vector3.ZERO
var input_vector = Vector3.ZERO
var animation_transitionx = 20

var is_running = false
var target_speed = Vector3.ZERO
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
	
	is_running = Input.is_action_pressed("move_faster")
	
	if input_vector != Vector3.ZERO:
		target_speed = input_vector * MAX_RUN_SPEED if is_running else \
				input_vector * MAX_WALK_SPEED
		
		velocity = velocity.move_toward(target_speed, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector3.ZERO, FRICTION * delta)
		
	animation_tree.update_animation(input_vector, is_running)
		
	velocity.y = 0 if is_on_floor() else velocity.y - 9.8 
	move_and_slide(velocity, Vector3.UP)
	
