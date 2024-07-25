extends Control

@onready var music_slider = get_node("VBoxContainer/HBoxContainer1/Music_Slider")
@onready var game_slider = get_node("VBoxContainer/HBoxContainer2/Game_Slider")
@onready var fullscreen_checkbox = get_node("VBoxContainer/HBoxContainer3/FullScreen/CheckBox")

const CONFIG_PATH = "user://settings.cfg"

func _on_Button_pressed():
	$UISound.play()
	$FadeIn.show()
	$FadeIn.fade_in()

func _on_CheckBox_pressed():
	$UISound.play()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if DisplayServer.window_get_mode() != DisplayServer.WINDOW_MODE_FULLSCREEN else DisplayServer.WINDOW_MODE_WINDOWED)
	save_settings()

func _on_FadeIn_fade_finished():
	get_tree().change_scene_to_file("res://Menu/Main Menu.tscn")

func _ready():
	set_process(true)
	load_settings()

func _process(_delta):
	if Input.is_action_pressed("key_exit"):
		$FadeIn.show()
		$FadeIn.fade_in()

func _on_Music_Slider_value_changed(value):
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus_index, value)  # Update the music bus volume
	if value == -30:
		AudioServer.set_bus_mute(music_bus_index, true)  # Mute the music bus
	else:
		AudioServer.set_bus_mute(music_bus_index, false)  # Unmute the music bus
	save_settings()

func _on_Game_Slider_value_changed(value):
	var sfx_bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(sfx_bus_index, value)  # Update the SFX bus volume
	if value == -30:
		AudioServer.set_bus_mute(sfx_bus_index, true)  # Mute the SFX bus
	else:
		AudioServer.set_bus_mute(sfx_bus_index, false)  # Unmute the SFX bus
	save_settings()

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_slider.value)
	config.set_value("audio", "sfx_volume", game_slider.value)
	config.set_value("video", "fullscreen", fullscreen_checkbox.button_pressed)
	config.save(CONFIG_PATH)

func load_settings():
	var config = ConfigFile.new()
	if config.load(CONFIG_PATH) == OK:
		var music_volume = config.get_value("audio", "music_volume", 0)
		var sfx_volume = config.get_value("audio", "sfx_volume", 0)
		music_slider.value = music_volume
		game_slider.value = sfx_volume
		
		# Load and set fullscreen checkbox state
		var is_fullscreen = config.get_value("video", "fullscreen", false)  # Default to false if not found
		fullscreen_checkbox.button_pressed = is_fullscreen
		
		# Apply audio settings (as in your original code)
		var music_bus_index = AudioServer.get_bus_index("Music")
		AudioServer.set_bus_volume_db(music_bus_index, music_volume)
		AudioServer.set_bus_mute(music_bus_index, music_volume == -30)
		var sfx_bus_index = AudioServer.get_bus_index("SFX")
		AudioServer.set_bus_volume_db(sfx_bus_index, sfx_volume)
		AudioServer.set_bus_mute(sfx_bus_index, sfx_volume == -30)
		
		# Apply fullscreen setting
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
