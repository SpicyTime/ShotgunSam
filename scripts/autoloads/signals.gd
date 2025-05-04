extends Node
signal swap_level(next_level_scene_path)
signal swap_scene
signal player_coin_change(new_value: int)
signal shake_camera(trauma_amount: float)
signal received_damage(damage: int)
signal health_changed(diff : int)
signal health_depleted
signal max_health_changed(diff : int)
signal player_shot()
signal gun_shot
signal gun_charge
signal game_stopwatch_changed(new_value: float)
signal button_hover
signal button_press()
signal text_display_finished()
signal dialogue_toggled(is_displaying: bool)
signal reset_level
signal laser_receiver_hit(id: int)
