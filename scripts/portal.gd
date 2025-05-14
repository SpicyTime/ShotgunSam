class_name Portal
extends Area2D
@export var flip_sprite: bool = false
@export var linked_portal: Portal = null
var can_teleport: bool = true
func set_linked_portal(portal: Portal) -> void:
	if portal == null:
		print("Portal could not be set to null value.")
		return
	linked_portal = portal

func start_immunity():
	linked_portal.can_teleport = false
	await get_tree().create_timer(1).timeout
	linked_portal.can_teleport = true
	
func teleport(body, position):
	body.global_position = position 
		
func _ready():
	$Sprite2D.flip_h = flip_sprite
	 
func _on_body_entered(body: Node2D) -> void:
	 
	var body_direction = body.global_position - global_position
	#Horizontal Portals
	if (flip_sprite and body_direction.x <= 0) or (not flip_sprite and body_direction.x > 0):
		return
	if (rotation == 90 and body_direction.y < 0) or  (rotation == -90 and body_direction.y >= 0):
		return
	#timer cooldown
	if not can_teleport  :
		return
	start_immunity()
	call_deferred("teleport", body, linked_portal.global_position)
	
