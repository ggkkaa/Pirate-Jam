extends Control

var scene_path_to_load
@onready var audio_player = $MusicPlayer
@onready var background = $Background/VBoxContainer/background
@onready var background2 = $Background/VBoxContainer/background2

const CONFIG_PATH = "user://settings.cfg"

func _on_Button_pressed(scene_to_load):
	scene_path_to_load = scene_to_load
	$UISound.play()
	$FadeIn.show()
	$FadeIn.fade_in()

func _ready():
	set_process(true)
	load_settings()
	background.scale.x = get_viewport_rect().size.x / 256
	background.scale.y = background.scale.x
	background2.scale.x = get_viewport_rect().size.x / 256
	background2.scale.y = background.scale.x
	
	background.position.x = -240
	background2.position.x = -240
	print(background.scale.x)
	$"Menu/CenterRow/Buttons/Start Game".grab_focus()
	for button in $Menu/CenterRow/Buttons.get_children():
		button.pressed.connect(_on_Button_pressed.bind(button.scene_to_load))
	

func _on_FadeIn_fade_finished():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file(scene_path_to_load)

func _process(_delta):
	if Input.is_action_pressed("key_exit"):
		$UISound.play()
		get_tree().quit()

func load_settings():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		var music_volume = config.get_value("audio", "music_volume", 0)
		var sfx_volume = config.get_value("audio", "sfx_volume", 0)
		
		# Load and set fullscreen checkbox state
		var is_fullscreen = config.get_value("video", "fullscreen", false)  # Default to false if not found
		
		# Apply audio settings (as in your original code)
		var music_bus_index = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(music_bus_index, music_volume)
		AudioServer.set_bus_mute(music_bus_index, music_volume == -30)
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(sfx_bus_index, sfx_volume)
		AudioServer.set_bus_mute(sfx_bus_index, sfx_volume == -30)
		
		# Apply fullscreen setting
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
