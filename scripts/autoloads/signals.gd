extends Node
@warning_ignore("unused_signal")
signal begin_shoot
@warning_ignore("unused_signal")
signal swap_level(next_level_scene_path)
@warning_ignore("unused_signal")
signal swap_scene
@warning_ignore("unused_signal")
signal player_coin_change(new_value: int)
@warning_ignore("unused_signal")
signal shake_camera(trauma_amount: float)
@warning_ignore("unused_signal")
signal received_damage(damage: int)
@warning_ignore("unused_signal")
signal health_changed(diff : int)
@warning_ignore("unused_signal")
signal max_health_changed(diff : int)
@warning_ignore("unused_signal")
signal player_shot()
@warning_ignore("unused_signal")
signal player_gun_charge
@warning_ignore("unused_signal")
signal gun_reload
@warning_ignore("unused_signal")
signal gun_shot
@warning_ignore("unused_signal")
signal gun_charge
@warning_ignore("unused_signal")
signal health_depleted
@warning_ignore("unused_signal")
signal game_stopwatch_changed(new_value: float)
@warning_ignore("unused_signal")
signal button_hover
@warning_ignore("unused_signal")
signal button_press()
@warning_ignore("unused_signal")
signal text_display_finished()
@warning_ignore("unused_signal")
signal dialogue_toggled(is_displaying: bool)
@warning_ignore("unused_signal")
signal player_bullet_change(new_value: int)
