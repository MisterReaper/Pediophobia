extends Node2D

@onready var darkness = $Darkness
@onready var player = $MainCharacter
@onready var backgroundMusicPlayer = $BackgroundMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.dialog(["Clark meant the stuff was in the back.", "He probably meant by the cabines."])
	var audiostream: AudioStream = preload("res://assets/sounds/jingleeee.mp3")
	
	audiostream.loop=true
	backgroundMusicPlayer.set_stream(audiostream)
	backgroundMusicPlayer.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func turn_off_lights():
	var audiostream: AudioStream = preload("res://assets/sounds/background-lights-out.mp3")
	audiostream.loop=true
	backgroundMusicPlayer.set_stream(audiostream)
	backgroundMusicPlayer.play()
	
				
	darkness.energy = 12
	player.flashlight.energy = 1
	$"NavigationRegion2D/progression-areas/doorInteractionArea".setDarknessEnabled(true)

func _on_main_character_tony_died() -> void:
	player.overlay.changeObjective("Objective:\nPress R to restart")


func _on_main_character_restart() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_tonys_bag_bag_is_picked_up() -> void:
	# Shit is about to go down
	player.overlay.changeObjective("Objective:\nGet out.")
	turn_off_lights()
	relocateEnemies()
	placeKey()
	
func relocateEnemies():
	pass

func removeAllEnemies():
	get_tree().call_group("enemy", "removeSelf")

func placeKey():
	var r = randi_range(0,2)
	var key = preload("res://objects/front_key.tscn").instantiate()
	add_child(key)
	#Please add proper positions then delete comment
	if r == 0:
		key.global_position = Vector2(375, 100)
	elif r == 1:
		key.global_position = Vector2(980, 585)
	else:
		key.global_position = Vector2(785, 125)

func _on_door_interaction_area_finish_game() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
