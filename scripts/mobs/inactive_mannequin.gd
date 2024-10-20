extends CharacterBody2D


const SPEED = 0.0
const JUMP_VELOCITY = -400.0
@onready var Sprite = $Sprite

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	Sprite.frame = rng.randi_range(0,4)
	
func _physics_process(delta: float) -> void:
	pass
