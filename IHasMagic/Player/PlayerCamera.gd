extends Spatial

const ray_length = 1000
const world_colision_mask = 1
const spawn_point = Vector3(0, 0.1, 7)

onready var camera = $Camera
onready var world = get_parent()
onready var current_level = world.get_node('Level')
onready var Player = preload("res://Player/Player.tscn")
onready var Marker = preload("res://Marker.tscn")

var last_marker
var player_hero

func _ready():
	player_hero = Player.instance()
	current_level.add_child(player_hero)
	player_hero.global_transform.origin = spawn_point

func _process(delta):
	var m_pos = get_viewport().get_mouse_position()
	if Input.is_action_just_pressed("move_player"):
		move_player_unit(m_pos)
		
func create_movement_marker(p_pos):
	if is_instance_valid(last_marker):
		last_marker.remove_marker()
	last_marker = Marker.instance()
	self.add_child(last_marker)
	last_marker.global_transform.origin = p_pos

func move_player_unit(m_pos):
	var result = raycast_from_mouse(m_pos, world_colision_mask)
	if result:
		create_movement_marker(result.position)
		player_hero.move_to(result.position)
	
func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = camera.project_ray_origin(m_pos)
	var ray_end = ray_start + camera.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask)
