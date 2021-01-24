extends KinematicBody2D

const MAX_SPEED = 50
const ACCELERATION = 150
const FRICTION = 500

var velocity = Vector2.ZERO
var sprite_orientation = 1
var is_running = false

onready var spritePlayer = $SpritePlayer

onready var animation = $AnimationPlayer
onready var animationTree = $AnimationTree

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - \
				Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - \
				Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	is_running = input_vector != Vector2.ZERO
	if is_running:
		if input_vector.x > 0:
			sprite_orientation = 1
		elif input_vector.x < 0:
			sprite_orientation = -1
		spritePlayer.scale.x = sprite_orientation
		velocity = velocity.move_toward(input_vector * MAX_SPEED, 
				ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	animationTree["parameters/conditions/isIdle"] = not is_running
	animationTree["parameters/conditions/isRunning"] = is_running
	
	velocity = move_and_slide(velocity)
