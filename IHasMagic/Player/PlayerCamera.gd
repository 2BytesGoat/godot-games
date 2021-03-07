extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30
const ray_length = 1000
const world_colision_mask = 1
const player_colision_mask = 10
const enemy_colision_mask = 100
const all_colision_mask = 111
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

func _process(delta):
	var m_pos = get_viewport().get_mouse_position()
	pan_camera(m_pos, delta)
	if Input.is_action_just_pressed("move_player"):
		player_unit_move(m_pos)
	if Input.is_action_just_pressed("cast_spell_1"):
		player_cast_spell(m_pos)
	if Input.is_action_pressed("ui_center_camera"):
		center_camera_on_player()

func pan_camera(m_pos, delta):
	var v_size = get_viewport().size
	var move_vec = Vector3()
	if m_pos.x < MOVE_MARGIN:
		move_vec = Vector3(-1, 0, -1)
	elif m_pos.x > v_size.x - MOVE_MARGIN:
		move_vec = Vector3(1, 0, 1)
	if m_pos.y < MOVE_MARGIN:
		move_vec = Vector3(1, 0, -1)
	elif m_pos.y > v_size.y - MOVE_MARGIN:
		move_vec = Vector3(-1, 0, 1)
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * MOVE_SPEED)
	
func center_camera_on_player():
	var direction = player_hero.global_transform.origin - transform.origin
	global_translate(direction)

func player_unit_move(m_pos):
	var result = raycast_from_mouse(m_pos, world_colision_mask)
	if result:
		create_movement_marker(result.position)
		player_hero.move_to(result.position)

func player_cast_spell(m_pos):
	var result = raycast_from_mouse(m_pos, world_colision_mask)
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
