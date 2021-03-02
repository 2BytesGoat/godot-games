extends KinematicBody

const gravity = 9.8
const mouse_sensitivity = 0.1

var speed = 10
var acceleration = 5

var jump_height = 3.5
var jumps_numer = 2

var blink_dist = 50

var damage = 100

var direction = Vector3.ZERO
var velocity  = Vector3.ZERO
var falling   = Vector3.ZERO

onready var pivot = $CharRotPivot
onready var gun_pivot = $GunPivot
onready var aimcast = $CharRotPivot/Camera/AimCast
onready var muzzle = $GunPivot/Mesh_Goose/Mesh_Goose/Muzzle
onready var bullet_hole = preload("res://weapons/BulletHole.tscn")

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

func _physics_process(delta):
	direction = Vector3.ZERO
	
	if Input.is_action_just_pressed("shoot"):
		if aimcast.is_colliding():
			var target = aimcast.get_collider()
			if target.is_in_group("Enemy"):
				print('hit enemy')
				target.health -= damage
			else:
				var b_hole = bullet_hole.instance()
				target.add_child(b_hole)
				b_hole.global_transform.origin = aimcast.get_collision_point()
				b_hole.look_at(aimcast.get_collision_point() + aimcast.get_collision_normal(), Vector3.UP)
	
	if is_on_floor():
		jumps_numer = 2
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
		
	if Input.is_action_just_pressed("jump") and jumps_numer > 0:
		falling.y = jump_height
		jumps_numer -= 1
	
	velocity += falling
	
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
