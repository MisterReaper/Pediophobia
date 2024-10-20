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

func addToContainer(objectName):
	print_debug(objectName)
	if(objectName == "key"):
		var uiKey = preload("res://objects/ui/ui_key.tscn").instantiate()
		container.add_child(uiKey)
		container.move_child(uiKey, 0)
		print_debug("Added a key to your inventory")

func removeFromContainer(object):
	container.remove_child(object)
