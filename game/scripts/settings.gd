extends Node

func _ready() -> void:
	get_tree().set_auto_accept_quit(false)
	load_settings()
	
func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
		get_tree().quit()
	
func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("display", "window_mode", DisplayServer.window_get_mode())
	config.set_value("volume", "master", AudioServer.get_bus_volume_linear(0))
	config.set_value("volume", "sfx", AudioServer.get_bus_volume_linear(1))
	config.set_value("volume", "music", AudioServer.get_bus_volume_linear(2))
	
	config.save("user://settings.cfg")

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		var mode = config.get_value("display", "window_mode", DisplayServer.WINDOW_MODE_MAXIMIZED)
		var master_vol = config.get_value("volume", "master", 1.0)
		var sfx_vol = config.get_value("volume", "sfx", 1.0)
		var music_vol = config.get_value("volume", "music", 1.0)
		
		DisplayServer.window_set_mode(mode)
		AudioServer.set_bus_volume_linear(0, master_vol)
		AudioServer.set_bus_volume_linear(1, sfx_vol)
		AudioServer.set_bus_volume_linear(2, music_vol)
