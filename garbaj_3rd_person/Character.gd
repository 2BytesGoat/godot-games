extends KinematicBody

var gravity = 9.8
var jump = 3.5
var falling = Vector3.ZERO

var mouse_sensitivity = 0.1

var speed = 10
var acceleration = 5

var direction = Vector3.ZERO
var velocity  = Vector3.ZERO

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
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		falling.y = jump
		
	if not is_on_floor():
		falling.y -= gravity * delta
	
	velocity += falling
	
	direction = direction.normalized()
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	
