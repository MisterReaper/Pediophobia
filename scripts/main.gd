extends Node2D

@onready var darkness = $Darkness
@onready var player = $MainCharacter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	darkness.energy = 12
	player.flashlight.energy = 1
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
