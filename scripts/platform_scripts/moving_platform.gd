extends StaticBody2D
class_name MovingPlatform
@export var texture_name:String = ""
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Initializes the texture
	if texture_name != "":
		var texture =  load("res://assets/art/platforms/" + texture_name)
		if texture != null:
			sprite_2d.texture = texture
		else:
			print("Null")
			return
	if collision_shape_2d == null:
		print("NUll")
		return
	#Adjusts the collision shape to match the texture
	collision_shape_2d.shape.extents = sprite_2d.texture.get_size() / 2
func reverse():
	pass
func stop_animation():
	pass

 
