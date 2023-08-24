extends Control

signal textbox_closed

@export var Resource: enemy #TODO

var rng = RandomNumberGenerator.new()
var rand

# Called when the node enters the scene tree for the first time.
func _ready():
	set_health($PlayerPanel/PlayerData/ProgressBar, State.current_health, State.max_health)
	rng.randomize()
	$Textbox.hide()
	$ActionsPanel.hide()

	display_text("A homeless man approaches you. He asks you for some money.")	
	await textbox_closed
	$ActionsPanel.show()

func set_health(progress_bar, health, max_health):
	progress_bar.value = health
	progress_bar.max_value = max_health
	progress_bar.get_node("Label").set_text(str(health) + "/" + str(max_health))

func display_text(text):
	$Textbox.show()
	$Textbox/Label.set_text(text)	

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





# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
