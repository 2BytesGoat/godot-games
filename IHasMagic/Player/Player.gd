extends KinematicBody

var path = []
var path_idx = 0
const move_speed = 550
onready var nav: Navigation = get_parent()
onready var dir_sprite: Spatial = $DirectionSprite
onready var projectile_spwan = $Weapon/Position3D
onready var Projectile = preload("res://Spells/Projectile.tscn")

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	pass

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_idx = 0
	
func update_orientation(target_pos):
	var global_pos = global_transform.origin
	rotation.y = (Vector2(target_pos.z, target_pos.x) - 
				  Vector2(global_pos.z, global_pos.x)).angle()
	
func cast_spell(target_pos):
	update_orientation(target_pos)
	var new_projectile = Projectile.instance()
	projectile_spwan.add_child(new_projectile)
	new_projectile.look_at(target_pos, Vector3.UP)
	new_projectile.launch()
	
func _physics_process(delta):
	var global_pos = global_transform.origin
	if path_idx < path.size():
		var move_vec = (path[path_idx] - global_pos)
		if move_vec.length() < 0.1:
			path_idx += 1
		else:
			update_orientation(path[path_idx])
			move_and_slide(move_vec.normalized() * move_speed * delta, Vector3.UP)
	
