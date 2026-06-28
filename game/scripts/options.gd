extends Control

var master = AudioServer.get_bus_index("Master")
var music = AudioServer.get_bus_index("Music")
var sfx = AudioServer.get_bus_index("SFX")

func _ready() -> void:
	hide()
	var mode_to_index = {
		DisplayServer.WINDOW_MODE_WINDOWED: 0,
		DisplayServer.WINDOW_MODE_MAXIMIZED: 1,
		DisplayServer.WINDOW_MODE_FULLSCREEN: 2,
	}
	var current_mode = DisplayServer.window_get_mode()
	$Window_mode.selected = mode_to_index.get(current_mode, 0)
	
	$Master.value = AudioServer.get_bus_volume_linear(master)
	$Music.value = AudioServer.get_bus_volume_linear(music)
	$SFX.value = AudioServer.get_bus_volume_linear(sfx)
	
	#pass
	
func _process(_delta: float) -> void:
	set_global_volume()
	set_music_volume()
	set_sfx_volume()
	
	#print(\
		#"MASTER : ", AudioServer.get_bus_volume_linear(master),\
	 	#" MUSIC : ", AudioServer.get_bus_volume_linear(music),\
		#" SFX : ", AudioServer.get_bus_volume_linear(sfx)
	#)
	
func _on_button_pressed() -> void:
	hide()
	for child in get_parent().get_children():
		print(child)
		if child != self:
			child.show()
		if child.name == "Options_hide":
			child.hide()

func set_global_volume():
	var vol_global_slider = $Master.value
	AudioServer.set_bus_volume_linear(master, vol_global_slider)
	
func set_music_volume():
	var vol_music_slider = $Music.value
	AudioServer.set_bus_volume_linear(music, vol_music_slider)
	
func set_sfx_volume():
	var vol_sfx_slider = $SFX.value
	AudioServer.set_bus_volume_linear(sfx, vol_sfx_slider)


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
