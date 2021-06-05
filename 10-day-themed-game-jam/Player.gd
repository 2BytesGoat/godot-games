extends KinematicBody2D

export var move_speed: float = 55.0

onready var slimeSprite = $Slime

onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
onready var animationState = animationTree.get("parameters/playback")

enum {
	MOVE,
	ATTACK
}

var facing_dir = 1
var state = MOVE
var move_destination = Vector2.ZERO
var facing_dir_deg = 0.0
var velocity = Vector2.ZERO

func _ready():
	animationPlayer.playback_speed = move_speed / 5

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ATTACK:
			attack_state(delta)
	
func move_state(delta):
	var input_vector = Vector2.ZERO
	if Input.is_action_just_pressed("ui_mouse_right"):
		move_destination = get_viewport().get_mouse_position()
		
	if move_destination.length() > 0:
		input_vector = position.direction_to(move_destination)
		facing_dir_deg = rad2deg(move_destination.angle_to_point(position))
	
	if position.distance_to(move_destination) > 3:
		velocity = input_vector * move_speed * delta
		slimeSprite.set_flip_h(abs(facing_dir_deg) < 90)
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Move/blend_position", input_vector)
		animationState.travel("Move")
	else:
		velocity = Vector2.ZERO
		animationState.travel("Idle")
	
	move_and_collide(velocity)
	
	if Input.is_action_just_pressed("ui_select"):
		state = ATTACK
	
func attack_state(_delta):
	velocity = Vector2.ZERO
	move_destination = Vector2.ZERO
	animationState.travel("Attack")
	
func _attack_ended():
	state = MOVE
