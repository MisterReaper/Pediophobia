extends Area2D

signal finishGame

@onready var player = $"../../../MainCharacter"
@onready var darknessEnabled = false
@onready var audioPlayer = $AudioStreamPlayer

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
		var audiostream: AudioStream = preload("res://assets/sounds/door-doesnt-open.mp3")
		audioPlayer.set_stream(audiostream)
		audioPlayer.play()
		return ["Why is it locked!?", "I have to find the key."]
	else:
		if not audioPlayer.playing:
			var audiostream: AudioStream = preload("res://assets/sounds/door-close.mp3")
			audioPlayer.set_stream(audiostream)
			audioPlayer.play()
		

func setDarknessEnabled(darknessEnabled):
	self.darknessEnabled = darknessEnabled

func _on_audio_stream_player_finished() -> void:
	if player.hasKeys:
		print_debug("A winner is you!")
		emit_signal("finishGame")
