extends Sprite2D
signal bagIsPickedUp
@onready var audioPlayer = $AudioStreamPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	if not audioPlayer.playing:
		var audiostream: AudioStream = preload("res://assets/sounds/bag-grab.mp3")
		audioPlayer.set_stream(audiostream)
		audioPlayer.play()
		emit_signal("bagIsPickedUp")
	
	
	return ["Fucking lights went out."]	


func _on_audio_stream_player_finished() -> void:
	queue_free() # function gets still completed don't worry ;D
	pass # Replace with function body.
