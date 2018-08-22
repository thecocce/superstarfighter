extends CenterContainer

export (String) var left = "A"
export (String) var right = "D"
export (String) var fire = "1"
export (String) var species = "ROBOLORDS"
export (int) var side = -1

signal selected 

var disabled = false
var selected = false

func _ready():
	# set shortcut for left and right
	# https://github.com/godotengine/godot/issues/15979
	var hotkey = InputEventKey.new() # weird, but no `.new`
	if left != "A":
		hotkey.scancode = KEY_LEFT
	else:
		hotkey.scancode = KEY_A
	var shortcut = ShortCut.new()
	shortcut.set_shortcut(hotkey)
	# and then on BaseButton
	$VBoxContainer/MarginContainer/HBoxContainer/Previous.set_shortcut(shortcut)
	
	hotkey = InputEventKey.new() # weird, but no `.new`
	if right != "D":
		hotkey.scancode = KEY_RIGHT
	else:
		hotkey.scancode = KEY_D
	shortcut = ShortCut.new()
	shortcut.set_shortcut(hotkey)
	# and then on BaseButton
	$VBoxContainer/MarginContainer/HBoxContainer/Next.set_shortcut(shortcut)
	print("My name is " + name + " and I have this side " + str(side))
	$VBoxContainer/Controls/CenterContainer/HBoxContainer/Right/CenterContainer/Panel/Key.text = right
	$VBoxContainer/Controls/CenterContainer/HBoxContainer/Left/CenterContainer/Panel/Key.text = left
	$VBoxContainer/Controls/CenterContainer/HBoxContainer/Fire/CenterContainer/Panel/Key.text = fire
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var ship = $VBoxContainer/CenterContainer/NinePatchRect/Sprite
	var characterSprite = $VBoxContainer/MarginContainer/HBoxContainer/CharacterContainer/Sprite
	
	ship.position = Vector2(50,50)
	ship.scale = Vector2(0.5, 0.5)
	characterSprite.position = Vector2(65,200)
	characterSprite.scale = Vector2(0.43, 0.43)
	
	species = global.available_species[global.chosen_species[name.to_lower()]]
	change_species(species)
	
	if disabled:
		disable_choice()
	
	if side != 0:
		ship.get_node("AnimationPlayer").play("standby")
	else:
		ship.get_node("AnimationPlayer").play_backwards("standby")
	ship.flip_h = not side
	characterSprite.flip_h = side

func change_species(specie):
	var ship = $VBoxContainer/CenterContainer/NinePatchRect/Sprite
	$VBoxContainer/SpeciesName.text = specie.to_upper()
	ship.texture = load("res://actors/"+specie.to_lower()+"_ship.png")
	$VBoxContainer/MarginContainer/HBoxContainer/CharacterContainer/Sprite.texture = load("res://assets/character_"+specie.to_lower()+"_1.png")
	print("changed_species into from "+species +" to " + specie)
	species = specie
#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
func _input(event):
	if event.is_action_pressed(name.to_lower()+"_fire") and not selected:
		disable_choice()
		selected = true
		var i = global.chosen_species[name.to_lower()]
		global.chosen_species[name.to_lower()] = i
		change_species(global.available_species[i])
		global.available_species.remove(i)
		emit_signal("selected")


func _on_Previous_pressed():
	var i = (global.chosen_species[name.to_lower()] - 1) % len(global.available_species)
	global.chosen_species[name.to_lower()] = i
	change_species(global.available_species[i])


func _on_Next_pressed():
	var i = (global.chosen_species[name.to_lower()] + 1) % len(global.available_species)
	global.chosen_species[name.to_lower()] = i
	change_species(global.available_species[i])

func disable_choice():
	$VBoxContainer/MarginContainer/HBoxContainer/Previous.disabled = true
	$VBoxContainer/MarginContainer/HBoxContainer/Next.disabled = true