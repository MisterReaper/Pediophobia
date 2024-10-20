extends Area2D

signal finishGame

@onready var player = $"../../../MainCharacter"
@onready var darknessEnabled = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	if darknessEnabled == false:
		return ["I need to get the bag."]
	elif darknessEnabled == true && player.hasKeys == false:
		player.overlay.changeObjective("Objective:\nFind the Key!")
		return ["Why is it locked!?", "I have to find the key."]
	else:
		print_debug("A winner is you!")
		emit_signal("finishGame")

func setDarknessEnabled(darknessEnabled):
	self.darknessEnabled = darknessEnabled
