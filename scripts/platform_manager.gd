class_name PlatformManager
extends Node
@export var platform_areas : Array[Rect2i]
func load_platform_texture(platform, tilemap, area):
	platform.load_texture(tilemap, area)
func initialize_moving_platform_textures():
	var children = get_children()
	var tilemap  = get_parent().find_child("Platforms")
	
	if children.size() != platform_areas.size():
		print("Sizes are not the same")
		return
	for i in range(children.size()):
		load_platform_texture(children[i], tilemap, platform_areas[i])
		#call_deferred("load_platform_texture", children[i], tilemap, platform_areas[i])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initialize_moving_platform_textures()

 
