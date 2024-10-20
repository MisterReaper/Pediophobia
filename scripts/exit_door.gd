extends Area2D

signal finishGame

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
	elif darknessEnabled == true:
		return ["Why is it locked!?", "I have to find the key."]
	else:
		emit_signal("finishGame")

func setDarknessEnabled(darknessEnabled):
	self.darknessEnabled = darknessEnabled
