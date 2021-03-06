extends KinematicBody

var path = []
var path_idx = 0
const move_speed = 12
onready var nav: Navigation = get_parent()
onready var dir_sprite: Spatial = $DirectionSprite
onready var Projectile = preload("res://Spells/Projectile.tscn")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_idx = 0
	
func _physics_process(delta):
	var global_pos = global_transform.origin
	if path_idx < path.size():
		var move_vec = (path[path_idx] - global_pos)
		if move_vec.length() < 0.1:
			path_idx += 1
		else:
			rotation.y = (Vector2(path[path_idx].z, path[path_idx].x) - 
					Vector2(global_pos.z, global_pos.x)).angle()
			move_and_slide(move_vec.normalized() * move_speed, Vector3.UP)
	
