extends Node2D

@onready var darkness = $Darkness
@onready var player = $MainCharacter
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.dialog(["Clark meant the stuff was in the back.", "He probably meant by the cabines."])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func turn_off_lights():
	darkness.energy = 12
	player.flashlight.energy = 1

func _on_main_character_tony_died() -> void:
	player.overlay.changeObjective("Objective:\nPress R to restart")


func _on_main_character_restart() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_tonys_bag_bag_is_picked_up() -> void:
	# Shit is about to go down
	print_debug("Yeah, I'm here")
	turn_off_lights()
	removeAllEnemies()
	
func relocateEnemies():
	pass

func removeAllEnemies():
	get_tree().call_group("enemy", "removeSelf")
