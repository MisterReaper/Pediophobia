extends CanvasLayer

@onready var objectiveText = $HBoxContainer/ObjectiveText
@onready var container = $HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func changeObjective(text):
	objectiveText.text = text

func addToContainer(object):
	container.add_child(object)

func removeFromContainer(object):
	container.remove_child(object)
