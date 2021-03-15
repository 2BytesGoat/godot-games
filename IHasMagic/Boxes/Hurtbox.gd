extends Area

signal is_in_lava(damage)
signal hit_by_projectile(area)
var damage_taken = 0

func _process(delta):
	var is_on_floor = false
	var is_in_lava = false
	for area in get_overlapping_areas():
		if area.is_in_group('floor'):
			is_on_floor = true
		elif area.is_in_group('lava'):
			is_in_lava = true
			damage_taken = area.damage
		if area.is_in_group('projectile'):
			emit_signal("hit_by_projectile", area)
	if not is_on_floor and is_in_lava:
		 emit_signal("is_in_lava", damage_taken)
