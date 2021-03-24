extends Spatial

const SCROLL_MARGIN = 20
const SCROLL_SPEED = 45
const MIN_ZOOM = 30
const MAX_ZOOM = 50
const ray_length = 1000
const world_colision_mask = 1
const player_colision_mask = 10
const enemy_colision_mask = 100
const spawn_point = Vector3(0, 0.1, 7)

onready var camera = $Camera
onready var world = get_parent()
onready var current_level = world.get_node('Level')
onready var Player = preload("res://Player/Player.tscn")
onready var Marker = preload("res://Player/Marker.tscn")

var last_marker
var player_hero

func _ready():
	#player_hero = Player.instance()
	#current_level.add_child(player_hero)
	#player_hero.global_transform.origin = spawn_point
	player_hero = current_level.get_node("Player")
	center_camera_on_player()
	
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			zomm_camera(event)

func _process(delta):
	var m_pos = get_viewport().get_mouse_position()
	pan_camera(m_pos, delta)
	if Input.is_action_just_pressed("move_player"):
		player_unit_move(m_pos)
	if Input.is_action_just_pressed("cast_spell_1"):
		player_cast_spell(m_pos)
	if Input.is_action_pressed("ui_center_camera"):
		center_camera_on_player()
		
func zomm_camera(event):
	if event.button_index == BUTTON_WHEEL_UP:
		camera.fov = max(MIN_ZOOM, camera.fov - 1.5)
	elif event.button_index == BUTTON_WHEEL_DOWN:
		camera.fov = min(MAX_ZOOM, camera.fov + 1.5)

func pan_camera(m_pos, delta):
	var v_size = get_viewport().size
	var move_vec = Vector3()
	if m_pos.x < SCROLL_MARGIN:
		move_vec += Vector3(0, 0, -1)
	elif m_pos.x > v_size.x - SCROLL_MARGIN:
		move_vec += Vector3(0, 0, 1)
	if m_pos.y < SCROLL_MARGIN:
		move_vec += Vector3(1, 0, 0)
	elif m_pos.y > v_size.y - SCROLL_MARGIN:
		move_vec += Vector3(-1, 0, 0)
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * SCROLL_SPEED)
	
func center_camera_on_player():
	var direction = player_hero.global_transform.origin - transform.origin
	direction.y = 0
	global_translate(direction)

func player_unit_move(m_pos):
	var result = raycast_from_mouse(m_pos, world_colision_mask)
	if result:
		create_movement_marker(result.position)
		player_hero.move_to(result.position)

func player_cast_spell(m_pos):
	var result = raycast_from_mouse(m_pos, world_colision_mask + enemy_colision_mask)
	if result:
		player_hero.cast_spell(result.position)

func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = camera.project_ray_origin(m_pos)
	var ray_end = ray_start + camera.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)

func create_movement_marker(p_pos):
	if is_instance_valid(last_marker):
		last_marker.remove_marker()
	last_marker = Marker.instance()
	self.add_child(last_marker)
	last_marker.global_transform.origin = p_pos
