class_name PlatformManager
extends Node
@export var platform_areas : Array[Rect2i]
func initialize_moving_platform_textures():
	var children = get_children()
	var tilemap  = get_parent().find_child("MovingPlatform")
	if children.size() != platform_areas.size():
		print("Sizes are not the same")
		return
	for i in range(children.size()):
		children[i].load_texture_from_tilemap(tilemap, platform_areas[i])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_moving_platform_textures()

 
