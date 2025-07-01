extends Panel
class_name Tip

var name_text : String
var boss_status_text : String
var level_text : String

@onready var name_label = $VBoxContainer/Label
@onready var boss_status_label = $VBoxContainer/Label2
@onready var level_label = $VBoxContainer/Label3

@onready var container = $VBoxContainer

func _process(delta: float) -> void:
	name_label.text = name_text
	
	if boss_status_text == "":
		boss_status_label.visible = false;
		container.add_theme_constant_override("separation", -1)
		
	boss_status_label.text = boss_status_text
	level_label.text = level_text
