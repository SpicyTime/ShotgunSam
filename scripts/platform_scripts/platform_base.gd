extends Node

func init_texture(texture_path: String) -> Texture2D:
	var texture = load(texture_path)
	return texture
func create_collider(texture: Texture2D) -> CollisionShape2D:
	if not texture:
		return null
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.extents = texture.get_size() / 2
	var collider = CollisionShape2D.new()
	collider.shape = shape
	return collider
