extends Node
signal begin_shoot
signal swap_level(next_level_scene_path)
signal player_coin_change(new_value: int)
signal shake_camera(trauma_amount: float)
signal received_damage(damage: int)
signal health_changed(diff : int)
signal max_health_changed(diff : int)
signal player_shot(bullets_left: int)
signal player_reload(bullet_count: int)
signal player_gun_charge
signal gun_reload
signal gun_shot
signal gun_charge
signal health_depleted
signal stop_watch_changed(new_value: float)
