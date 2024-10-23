extends AnimatedSprite2D

class_name cabine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frame = randi_range(0,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func closeCabine():
	print_debug("is closed now")
	frame = 1
	
func leaveCabine():
	print_debug("leaving cabine")
	frame = 0

func isClosed():
	return frame
	
