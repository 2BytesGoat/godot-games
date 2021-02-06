extends KinematicBody2D

const MAX_SPEED = 75
const ACCELERATION = 500
const FRICTION = 500
const SHOOT_FORCE = 10

const arrowProjectile = preload("res://Projectiles/Arrow.tscn")

var state = MOVE
var velocity = Vector2.ZERO
var cursor_angle = 0
var flip_sprite_player = false
var shoot_angle = 0

enum{
	MOVE,
	SHOOT,
	ATTACK
}

onready var playerSNone = $PlayerSpriteNode
onready var spritePlayer = $PlayerSpriteNode/SpritePlayer
onready var cursorPlayer = $CursorPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")
onready var shootArrowPosition = $PlayerSpriteNode/SpritePlayer/ArrowSpawnPosition

func _physics_process(delta):
	var cursor_position = get_viewport().get_mouse_position()
	cursor_angle = get_angle_to(cursor_position)
	cursorPlayer.rotation = cursor_angle
	
	match state:
		MOVE:
			move_state(delta)
		SHOOT:
			shoot_state(delta)
		ATTACK:
			attack_state(delta)
	
func shoot_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("ShootArrow")
	
func shoot_animation_finished():
	var arrow = arrowProjectile.instance()
	shootArrowPosition.add_child(arrow)
	arrow.launch(shoot_angle, SHOOT_FORCE)
	state = MOVE
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	animationState.travel("MeleLight")
	
func attack_animation_finished():
	state = MOVE

func move_state(delta):	
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - \
				Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - \
				Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		if input_vector.x != 0: # solves flipping issue when moving vertically
			flip_sprite_player = input_vector.x > 0
		velocity = velocity.move_toward(input_vector * MAX_SPEED, 
				ACCELERATION * delta)
		animationState.travel("Run")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		animationState.travel("Idle")
	velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("hero_shoot"):
		flip_sprite_player = abs(cursor_angle) < 1.5
		shoot_angle = cursor_angle
		state = SHOOT
		
	if Input.is_action_just_pressed("hero_attack"):
		flip_sprite_player = abs(cursor_angle) < 1.5
		state = ATTACK
		
	playerSNone.scale.y = 1 if flip_sprite_player else -1
