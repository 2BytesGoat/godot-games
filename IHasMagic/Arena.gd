extends CSGCylinder

onready var timer = $Timer
var damage = 0

func _on_Timer_timeout():
	self.scale *= Vector3(0.8, 1.0, 0.8)
	timer.start()
	
