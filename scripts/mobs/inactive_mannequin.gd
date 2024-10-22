extends AnimatedSprite2D


const SPEED = 0.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	frame = rng.randi_range(0,4)
	add_to_group("inactive_mannequin")
	
func _process(delta: float) -> void:
	pass

func removeSelf():
	queue_free()
