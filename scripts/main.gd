extends Node2D

@onready var darkness = $Darkness
@onready var player = $MainCharacter
@onready var backgroundMusicPlayer = $BackgroundMusic
@onready var mobNode = $mobs

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
	get_tree().call_group("inactive_mannequin", "removeSelf")
	#
	spawnMannequin(Vector2(250, 320), Vector2(40, 320))
	spawnMannequin(Vector2(256, 350), Vector2(256, 590))
	spawnMannequin(Vector2(350, 570), Vector2(1100, 570))
	spawnMannequin(Vector2(620, 500), Vector2(620, 130))
	spawnMannequin(Vector2(720, 130), Vector2(720, 500))
	spawnMannequin(Vector2(907, 110), Vector2(0, 0))
	spawnMannequin(Vector2(955, 110), Vector2(0, 0))
	spawnMannequin(Vector2(1000, 110), Vector2(0, 0))
	spawnMannequin(Vector2(375, 100), Vector2(375, 500))
	spawnMannequin(Vector2(545, 100), Vector2(450, 390))
	spawnMannequin(Vector2(1100, 265), Vector2(820, 265))
	spawnMannequin(Vector2(820, 120), Vector2(820, 500))


func spawnMannequin(pos, posPointB):
	var mannequin = preload("res://objects/mobs/mannequin.tscn").instantiate()
	mannequin.global_position = pos
	mannequin.patrolPointB = posPointB
	mannequin.z_index=1
	add_child(mannequin)
	
	#
	# Add the above code a second time for patrol point B
	
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
		key.global_position = Vector2(725, 150)

func _on_door_interaction_area_finish_game() -> void:
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
