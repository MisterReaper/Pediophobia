extends AnimatedSprite2D
class_name clothing_rack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	frame = rng.randi_range(0,7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
