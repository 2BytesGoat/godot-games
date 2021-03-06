extends Spatial

func remove_marker():
	queue_free()

func _on_Timer_timeout():
	queue_free()
