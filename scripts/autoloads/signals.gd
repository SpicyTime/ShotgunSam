extends Node
signal begin_shoot
signal change_scene(next_level_scene_path)
signal player_coin_change(new_value: int)
signal shake_camera(trauma_amount: float)
signal received_damage(damage: int)
signal health_changed(diff : int)
signal max_health_changed(diff : int)
signal health_depleted
