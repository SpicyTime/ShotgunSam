extends Node
#Player
signal player_coin_change(new_value: int)
signal player_shot()
#Gun
signal gun_shot
signal gun_charge
#Camera
signal shake_camera(trauma_amount: float)
#Dialogue
signal text_display_finished()
signal dialogue_toggled(is_displaying: bool)
#Health
signal health_changed(diff : int)
signal health_depleted
signal max_health_changed(diff : int)
signal received_damage(damage: int)
#Laser
signal laser_receiver_hit(id: int)
signal laser_receiver_unhit(id: int)
signal mirror_hit(laser: Laser)
#Button 
signal button_hover
signal button_press()
#Level
signal swap_level(next_level_scene_path)
signal swap_scene
signal reset_level
#Game
signal game_stopwatch_changed(new_value: float)
