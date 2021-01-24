extends KinematicBody2D

const MAX_SPEED = 75
const ACCELERATION = 500
const FRICTION = 500

const arrowProjectile = preload("res://Projectiles/Arrow.tscn")

enum{
	MOVE,
	SHOOT
}

var velocity = Vector2.ZERO
var flip_sprite_player = false
var state = MOVE

onready var spritePlayer = $SpritePlayer
onready var cursorPlayer = $CursorPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var shootArrowPosition = $SpritePlayer/ArrowSpawnPosition

func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	cursorPlayer.look_at(mouse_pos)
	match state:
		MOVE:
			move_state(delta)
		SHOOT:
			shoot_state(delta)
	
func shoot_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("ShootArrow")
	
func shoot_animation_finished():
	var arrow = arrowProjectile.instance()
	shootArrowPosition.add_child(arrow)
	arrow.launch(0.5)
	state = MOVE

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - \
				Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - \
				Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		flip_sprite_player = input_vector.x > 0
		spritePlayer.set_flip_h(flip_sprite_player) # flip sprite
		velocity = velocity.move_toward(input_vector * MAX_SPEED, 
				ACCELERATION * delta)
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("hero_shoot"):
		flip_sprite_player = get_local_mouse_position().x > 0
		spritePlayer.set_flip_h(flip_sprite_player) # flip sprite
		state = SHOOT
