extends KinematicBody

const gravity = 9.8
const mouse_sensitivity = 0.1

var speed = 10
var acceleration = 5

var jump = 3.5
var jump_num = 2

var blink_dist = 50

var direction = Vector3.ZERO
var velocity  = Vector3.ZERO
var falling   = Vector3.ZERO

onready var pivot = $CharRotPivot
onready var gun_pivot = $GunPivot

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		pivot.rotation.x = clamp(pivot.rotation.x, deg2rad(-70), deg2rad(30))
		gun_pivot.rotate_x(deg2rad(-event.relative.y) * mouse_sensitivity)
		gun_pivot.rotation.x = clamp(pivot.rotation.x, deg2rad(-70), deg2rad(30))		

func _process(delta):
	direction = Vector3.ZERO
	
	if is_on_floor():
		jump_num = 2
		falling = Vector3.ZERO
	else:
		falling.y -= gravity * delta
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	direction = direction.normalized()
		
	if Input.is_action_just_pressed("blink"):
		direction *= blink_dist
		
	if Input.is_action_just_pressed("jump") and jump_num > 0:
		falling.y = jump
		jump_num -= 1
	
	velocity += falling
	
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	
