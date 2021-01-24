extends KinematicBody2D

const MAX_SPEED = 75
const ACCELERATION = 150
const FRICTION = 500

enum{
	MOVE,
	SHOOT
}

var velocity = Vector2.ZERO
var state = MOVE

onready var spritePlayer = $SpritePlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		SHOOT:
			shoot_state(delta)
	
func shoot_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("ShootArrow")
	
func shoot_animation_finished():
	state = MOVE

func move_state(delta):
	var mouse_position = get_local_mouse_position()
	spritePlayer.set_flip_h(mouse_position.x > 0) # flip sprite
	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - \
				Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - \
				Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	var shoot_arror = Input.is_action_just_pressed("hero_shoot")
	
	if shoot_arror:
		state = SHOOT
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * MAX_SPEED, 
				ACCELERATION * delta)
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	velocity = move_and_slide(velocity)
