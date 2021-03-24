extends KinematicBody

const move_speed = 600
const FRICTION = 25 # consider scaling friction with current health

enum {
	MOVE,
	SHOOT
}

var state = MOVE
var travel_path = []
var travel_path_idx = 0
var knockback_vector = Vector3.ZERO
var movement = Vector3.ZERO

onready var nav: Navigation = get_parent()
onready var status = $Status
onready var dir_sprite: Spatial = $DirectionSprite
onready var projectile_spwan = $Weapon/Position3D
onready var anim_tree = $AnimationTree
onready var Projectile = preload("res://Spells/Projectile.tscn")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
	
func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		SHOOT:
			shoot_state(delta)

func move_to(target_pos):
	travel_path = nav.get_simple_path(global_transform.origin, target_pos)
	travel_path_idx = 0
	
func cast_spell(target_pos):
	travel_path = []
	update_orientation(target_pos)
	state = SHOOT
	
func update_orientation(target_pos):
	var global_pos = global_transform.origin
	rotation.y = (Vector2(target_pos.z, target_pos.x) - 
				  Vector2(global_pos.z, global_pos.x)).angle()
			
func move_state(delta):
	if travel_path_idx < travel_path.size():
		var move_vec = (travel_path[travel_path_idx] - global_transform.origin)
		if move_vec.length() < 0.1:
			travel_path_idx += 1
		else:
			update_orientation(travel_path[travel_path_idx])
			movement = move_and_slide(move_vec.normalized() * move_speed * delta, Vector3.UP)
			anim_tree.set("parameters/MoveBlend/blend_amount", 1)
	else:
		movement = move_and_slide(Vector3.ZERO, Vector3.UP)
		anim_tree.set("parameters/MoveBlend/blend_amount", 0)
	
	if knockback_vector != Vector3.ZERO:
		knockback_vector = knockback_vector.move_toward(Vector3.ZERO, FRICTION * delta)
		knockback_vector = move_and_slide(knockback_vector)
		
func shoot_state(_delta):
	anim_tree.set("parameters/MoveBlend/blend_amount", 0)
	anim_tree.set("parameters/ShootSpell/active", 1)
	
func launch_spell():
	var new_projectile = Projectile.instance()
	projectile_spwan.add_child(new_projectile) 
	new_projectile.launch()
	
func _animation_ended():
	state = MOVE
	
func _on_Status_no_health():
	queue_free()

func _on_Hurtbox_is_in_lava(damage):
	status.health -= damage

func _on_Hurtbox_hit_by_projectile(area):
	status.health -= area.damage
	self.knockback_vector = area.knockback_vector * area.knockback_power
