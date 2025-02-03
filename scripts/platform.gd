extends AnimatableBody2D

func load_texture_from_tilemap(tilemap_layer : TileMapLayer, area : Rect2i):
	$Sprite2D.texture = $TextureFromTilemap.extract_tilemap_texture(tilemap_layer, area)
