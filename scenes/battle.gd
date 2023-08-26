extends Control

signal textbox_closed

@export var enemy: Resource

var current_player_health = 0
var current_enemy_health = 0
var is_defending = false

var rng = RandomNumberGenerator.new()
var rand

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health($EnemyContainer/ProgressBar, enemy.health, enemy.health)
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	$EnemyContainer/Enemy.texture = enemy.texture

	current_player_health = State.current_health
	current_enemy_health = enemy.health


	rng.randomize()
	$Textbox.hide()
	$ActionsPanel.hide()

	display_text("A "+enemy.name+" approaches you. He asks you for some money.")	
	await textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").set_text(str(health) + "/" + str(max_health))

func display_text(text):
	$ActionsPanel.hide()
	$Textbox.show()
	$Textbox/Label.set_text(text)	

func enemy_turn():
	display_text(enemy.name+" lunges at you fierecly!")	
	await textbox_closed

	if is_defending == true:
		#Player is defending
		#Enemy damage is halved
		enemy.damage = enemy.damage / 2
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)

		display_text(enemy.name+" dealt "+str(enemy.damage)+" damage to the you!")
		await textbox_closed

		is_defending = false
		enemy.damage = enemy.damage * 2

		#Play pulsating enemy_damage (res://scenes/battle.tscn/AnimationPlayer/shake_mini)
		$AnimationPlayer.play("shake_mini")
		await $AnimationPlayer.animation_finished

	else:
		#Enemy health subtracts player damage (State.damage res://src/State.gd)
		current_player_health = max(0, current_player_health - enemy.damage)
		set_health($PlayerPanel/PlayerData/ProgressBar, current_player_health, State.max_health)
		#Play pulsating enemy_damage (res://scenes/battle.tscn/AnimationPlayer/shake)
		$AnimationPlayer.play("shake")
		await $AnimationPlayer.animation_finished
		display_text(enemy.name+" dealt "+str(enemy.damage)+" damage to the you!")
		await textbox_closed


	#Check if player is dead
	if current_player_health == 0:
		#Player is dead
		display_text("All fades to black...")
		await textbox_closed
		#Play player_died (res://scenes/battle.tscn/AnimationPlayer/player_died)
		$AnimationPlayer.play("player_died")
		await $AnimationPlayer.animation_finished
		await get_tree().create_timer(5.0).timeout
		get_tree().quit()
	else:
		#Player is alive
		$ActionsPanel.show()

func _input(event):
	if (Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)) and $Textbox.visible:
		$Textbox.hide()
		emit_signal("textbox_closed")

func _on_run_pressed():
	#rand = rng.randi_range(1, 5)
	#if(rand = "1"):
	display_text("You successfully outrun the drug addled maniac!")
	await textbox_closed
	await get_tree().create_timer(2.0).timeout
	get_tree().quit()
	#else
		#display_text("You cannot outrun him, the fight continues.")
		#await textbox_closed

func _on_attack_pressed():
	display_text("You swing your fists wildly!")	
	await textbox_closed

	#Enemy health subtracts player damage (State.damage res://src/State.gd)
	current_enemy_health = max(0, current_enemy_health - State.damage)
	set_health($EnemyContainer/ProgressBar, current_enemy_health, enemy.health)

	#Play pulsating enemy_damage (res://scenes/battle.tscn/AnimationPlayer/enemy_damaged)
	$AnimationPlayer.play("enemy_damaged")
	await $AnimationPlayer.animation_finished

	display_text("You dealt "+str(State.damage)+" damage to the "+enemy.name+"!")
	await textbox_closed

	#Check if enemy is dead
	if current_enemy_health == 0:
		#Enemy is dead
		display_text("You have defeated the "+enemy.name+"!")
		await textbox_closed
		#Play enemy_died (res://scenes/battle.tscn/AnimationPlayer/enemy_died)
		$AnimationPlayer.play("enemy_died")
		await $AnimationPlayer.animation_finished
		get_tree().quit()
	else:
		#Enemy is alive
		enemy_turn()

func _on_defend_pressed():
	is_defending = true

	display_text("You brace yourself...")	
	await textbox_closed

	await get_tree().create_timer(0.25).timeout

	enemy_turn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
