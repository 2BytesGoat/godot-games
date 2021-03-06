extends Spatial

func _process(delta):
	self.scale *= 1 - (delta * 5)

func remove_marker():
	queue_free()

func _on_Timer_timeout():
	queue_free()
