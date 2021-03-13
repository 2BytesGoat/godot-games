extends Area

signal is_in_lava

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for body in get_overlapping_bodies():
		if body is GridMap:
			var pos = self.global_transform.origin - Vector3.UP 
			var cell_pos = body.world_to_map(pos)
			var surface_type = body.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z)
			if surface_type == 3:
				emit_signal("is_in_lava")
