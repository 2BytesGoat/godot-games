extends KinematicBody

var path = []
var path_idx = 0
const move_speed = 12
onready var nav: Navigation = get_parent()

func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_idx = 0
	
func _physics_process(delta):
	if path_idx < path.size():
		var move_vec = (path[path_idx] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_idx += 1
		else:
			move_and_slide(move_vec.normalized() * move_speed, Vector3.UP)
