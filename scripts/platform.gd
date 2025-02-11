extends AnimatableBody2D
@onready var texture_extractor: TextureFromTilemap = $TextureFromTilemap
@onready var sprite: Sprite2D = $Sprite
@onready var collider: CollisionShape2D = $PlatformCollider

func auto_collider_size(texture: Texture2D):
	var rect_shape = collider.shape
	rect_shape.size = Vector2(texture.get_width(), texture.get_height())
func load_texture(tilemap: TileMapLayer, area: Rect2i):
	var texture: Texture2D = texture_extractor.extract_tilemap_texture(tilemap, area)
	sprite.texture = texture
	#Sets the size of the shape to the size of the texture
	auto_collider_size(texture)
