extends Sprite2D
signal bagIsPickedUp

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	queue_free() # function gets still completed don't worry ;D
	emit_signal("bagIsPickedUp")
	return ["Fucking lights went out."]	
