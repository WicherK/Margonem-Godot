extends Node
class_name ISkill

enum DAMAGE_TYPE { PHYSICAL, MAGIC }

@export var damage_type: DAMAGE_TYPE

@export var skill_name: String
@export var description: String

@export var mana_cost: int
@export var damage: int

@export var animation: AnimatedSprite2D

# Cooldown mechanic
var round_cooldown = 0
var round_passed = 0

func visual_attack() -> void:
	if animation != null:
		animation.play()
	
func take_damage(enemy: ICharacter) -> void:
	enemy.apply_damage(damage, damage_type)
	
func use(enemy: ICharacter) -> void:
	if self.get_script() != ISkill:
		push_error("Overriding attack() is not allowed in derived classes!")
		return
		
	visual_attack()
	await animation.animation_finished
	take_damage(enemy)
