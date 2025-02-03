class_name TextureFromTilemap
extends Node
@onready var terrain: TileMapLayer = $"../Terrain"

func extract_tilemap_texture(layer : TileMapLayer, rect : Rect2i):
	var tile_set = layer.tile_set
	var cell_size = tile_set.tile_size
	var image := Image.create(rect.size.x * cell_size.x, rect.size.y * cell_size.y, false, Image.FORMAT_RGBA8)
	image.fill(Color(0, 0, 0, 0))
	print(rect)
	for x in range(rect.position.x, rect.end.x):
		for y in range(rect.position.y, rect.end.y):
			var tile_pos = Vector2i(x, y)
			print("Tile Position" + str(tile_pos))
			var source_id = layer.get_cell_source_id(tile_pos)
			print("Source ID " + str(source_id))
			var atlas_coords = layer.get_cell_atlas_coords(tile_pos)
			print("Atlas Coordinates" + str(atlas_coords))
			if source_id == -1:
				continue
			var tile_texture = tile_set.get_source(source_id) as TileSetAtlasSource
			if tile_texture:
				#Gets the actual tileset texture. In this case it is getting the Tileset.png
				var atlas_texture = tile_texture.texture
				 
				if atlas_texture:
					var tile_region = tile_texture.get_tile_texture_region(atlas_coords)
					print("Tile Region" + str(tile_region))
					var tile_img = atlas_texture.get_image()
					
					if tile_img:
						print("INTERESTING " + str((tile_pos - rect.position) * cell_size))
						image.blit_rect(tile_img, tile_region, (tile_pos - rect.position) * cell_size)
	var texture = ImageTexture.create_from_image(image)
	image.save_png("res://assets/art/tilemap_capture.png")
	return texture
func _ready():
	extract_tilemap_texture(terrain, Rect2i(-1, 2,3, 5))
