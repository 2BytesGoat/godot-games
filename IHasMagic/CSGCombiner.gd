extends CSGCombiner

onready var arena = $Arena
onready var timer = $Timer

func _on_Timer_timeout():
	arena.scale *= 0.8
	timer.start()
