extends CharacterBody2D
@export var texture_name:String = ""
@export var risable: bool = false
@export var speed: float = 10
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var rise_timer: Timer = $RiseTimer
@onready var falling_platform: CharacterBody2D = $"."

var gravity = 980
var start_position = Vector2.ZERO
var rising: bool = false
var falling: bool = false

func fall():
	if not falling:
		falling = true
		rise_timer.start()
		print("Fall")
func rise():
	if risable:
		rising = true
		falling = false
		 
func _ready() -> void:
	#Initializes the texture
	if texture_name != "":
		var texture =  load("res://assets/art/platforms/" + texture_name)
		if texture != null:
			sprite_2d.texture = texture
		else:
			return
	if collision_shape_2d == null:
		return
	#Adjusts the collision shape to match the texture
	collision_shape_2d.shape.extents = sprite_2d.texture.get_size() / 2
	$Area2D/CollisionShape2D.shape.extents.x = sprite_2d.texture.get_size().x / 2
	$Area2D.position.y = collision_shape_2d.position.y - 40
 
	start_position = global_position
	 
func _physics_process(delta: float) -> void:
	if rising:
		if global_position.y <= start_position.y:
			rising = false
			global_position = start_position
			velocity = Vector2.ZERO
		else:
			velocity.y = -delta * speed * 10
		move_and_slide()
	elif falling:
		velocity.y += gravity * delta
		move_and_slide()
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == falling_platform:
		return
	fall()

func _on_rise_timer_timeout() -> void:
	rise()
