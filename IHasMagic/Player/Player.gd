extends KinematicBody

const move_speed = 550
const FRICTION = 150

var travel_path = []
var travel_path_idx = 0
var knockback_vector = Vector3.ZERO

onready var nav: Navigation = get_parent()
onready var status = $Status
onready var dir_sprite: Spatial = $DirectionSprite
onready var projectile_spwan = $Weapon/Position3D
onready var Projectile = preload("res://Spells/Projectile.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)

func move_to(target_pos):
	travel_path = nav.get_simple_path(global_transform.origin, target_pos)
	travel_path_idx = 0
	
func update_orientation(target_pos):
	var global_pos = global_transform.origin
	rotation.y = (Vector2(target_pos.z, target_pos.x) - 
				  Vector2(global_pos.z, global_pos.x)).angle()
	
func cast_spell(target_pos):
	travel_path = []
	update_orientation(target_pos)
	var new_projectile = Projectile.instance()
	projectile_spwan.add_child(new_projectile)
	target_pos.y = global_transform.origin.y
	new_projectile.launch()
	
func _physics_process(delta):
	var global_pos = global_transform.origin
	
	knockback_vector = knockback_vector.move_toward(Vector3.ZERO, FRICTION * delta)
	knockback_vector = move_and_slide(knockback_vector)
	
	if travel_path_idx < travel_path.size():
		var move_vec = (travel_path[travel_path_idx] - global_pos)
		if move_vec.length() < 0.1:
			travel_path_idx += 1
		else:
			update_orientation(travel_path[travel_path_idx])
			move_and_slide(move_vec.normalized() * move_speed * delta, Vector3.UP)
	
func _on_Status_no_health():
	queue_free()

func _on_Hurtbox_area_entered(area):
	status.health -= area.damage
	knockback_vector = area.knockback_vector * area.knockback_power
