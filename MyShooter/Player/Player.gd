extends KinematicBody

export var mouse_sensitivity: float = 0.1
export var speed: float = 10.0
export var acceleration: float = 4.0
export var jump_height: float = 2.5
export var dash_dist: float = 50.0
export var max_nb_jumps: int = 2

const gravity = 9.8
var velocity: Vector3 = Vector3.ZERO
var player_push: Vector3 = Vector3.ZERO
var nb_jumps: int = max_nb_jumps

onready var vision_pivot: Spatial = $VisionPivot
onready var gun_pivot: Spatial = $GunPivot

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if event is InputEventMouseMotion:
		aim(event)

func _physics_process(delta):
	
	if is_on_floor():
		player_push.y = 0
	else:
		player_push.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and nb_jumps > 0:
		player_push.y = jump_height
		nb_jumps -= 1
	elif is_on_floor():
		nb_jumps = max_nb_jumps
	
	var direction: Vector3 = move_btn_pressed()
	var propulsion: float  = dash_btn_pressed()
	
	velocity += player_push
	
	velocity = velocity.linear_interpolate(direction * propulsion, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP, true)

func aim(event: InputEventMouseMotion) -> void:
	# rotate player
	rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
	# rotate camera
	vision_pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
	vision_pivot.rotation.x = clamp(vision_pivot.rotation.x, deg2rad(-70), deg2rad(30))
	gun_pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
	gun_pivot.rotation.x = clamp(gun_pivot.rotation.x, deg2rad(-70), deg2rad(30))

func move_btn_pressed() -> Vector3:
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
		
	return direction

func dash_btn_pressed() -> float:
	if Input.is_action_just_pressed("dash"):
		return dash_dist * speed
	return speed

