extends KinematicBody

export var mouse_sensitivity: float = 0.1
export var speed: float = 10.0
export var acceleration: float = 4.0
export var jump_height: float = 3.0
export var dash_dist: float = 5.0
export var max_nb_jumps: int = 2

const gravity = 9.8
var velocity: Vector3 = Vector3.ZERO
var direction: Vector3 = Vector3.ZERO
var player_fall_force: float = 0
var nb_jumps: int = max_nb_jumps

var equiped_gun: Spatial

onready var vision_pivot: Spatial = $VisionPivot
onready var gun_pivot: Spatial = $GunPivot
onready var front_camera: Camera = $VisionPivot/FrontCamera
onready var back_camera: Camera = $VisionPivot/BackCamera
onready var active_camera: Camera = front_camera
onready var aimcast: RayCast = active_camera.get_node("AimCast")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	equiped_gun = $GunPivot/GunPlacement/GooseGun

func _input(event) -> void:
	if Input.is_action_just_pressed("swap_camera"):
		swap_cameras()
		aimcast = active_camera.get_node("AimCast")
		
	if Input.is_action_just_pressed("fire_gun"):
		if aimcast.is_colliding():
			var target = aimcast.get_collision_point()
			equiped_gun.open_fire(target)
		
	if Input.is_action_just_pressed("jump") and nb_jumps > 0:
		player_fall_force = jump_height
		nb_jumps -= 1
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if event is InputEventMouseMotion:
		aim(event)
		
	update_player_direction()

func _physics_process(delta):
	if is_on_floor():
		player_fall_force = 0
		nb_jumps = max_nb_jumps
	else:
		player_fall_force -= gravity * delta
	
	velocity.y += player_fall_force
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP, true)

func aim(event: InputEventMouseMotion) -> void:
	# rotate player
	rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
	# rotate camera
	vision_pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
	vision_pivot.rotation.x = clamp(vision_pivot.rotation.x, deg2rad(-70), deg2rad(30))
	gun_pivot.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
	gun_pivot.rotation.x = clamp(gun_pivot.rotation.x, deg2rad(-70), deg2rad(30))

func swap_cameras() -> void:
	front_camera.current = back_camera.current
	back_camera.current = not front_camera.current
	
	if front_camera.current:
		active_camera = front_camera
	else:
		active_camera = back_camera

func update_player_direction() -> void:
	direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	elif Input.is_action_pressed("move_left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	
