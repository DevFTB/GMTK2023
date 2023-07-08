extends Node2D
class_name ComboLifecycle

class ActionLifecycle:
	signal started
	signal completed
	signal hit
	signal failed
	
	var parent: Node2D
	var action : BossAction
	# when the animations start playing, for charge attacks, the play must start holding now.
	var start_beat : int
	var hit_beat : int
	var end_beat : int
	
	var has_started = false
	
	var success_hit = false

	func _init(parent: Node2D, action: BossAction, offset = 0):
		self.parent  = parent
		self.action = action
		start_beat = offset
		hit_beat = offset + action.amount_of_beats
		end_beat = hit_beat + action.amount_of_cooldown_beats
		
		print("start ", start_beat, " hit: ", hit_beat, " end: ", end_beat)
		
	func process_beat(beat: int):
		if not has_started and beat >= start_beat:
			has_started = true
			started.emit()
			
		if has_started and beat >= end_beat and success_hit:
			completed.emit()
			
		if has_started and beat >= hit_beat + 1 and not success_hit:
			failed.emit()
			
	func next_player_beat() -> int:
		return hit_beat
	
	func rhythm_hit(strength: float, pressed: bool = true):
		if pressed:
			if strength == 0:
				failed.emit()
			else:
				if not success_hit:
					success_hit = true
					execute(strength)
					hit.emit()
	
	func execute(strength: float, position: Vector2 = Vector2.ZERO, direction: Vector2 = Vector2.DOWN):
		if action.action_scene:
			var action_instance = action.action_scene.instantiate()
			action_instance.strength = strength
		
			action_instance.position = position
			action_instance.rotation = direction.angle()
		
			parent.add_child(action_instance)
			
		else:
			print("action ", action.action_name, " with strength ", strength)
		pass

class HoldActionLifecycle:
	extends ActionLifecycle
	
	var press_strength = 0
	
	func process_beat(beat: int):
		if has_started and beat >= hit_beat + 1 and not success_hit:
			print("didn't hit in time")
			failed.emit()
			
		if has_started and beat >= end_beat and success_hit:
			completed.emit()
			

	
	func rhythm_hit(strength: float, pressed: bool = true):
		if strength == 0:
			failed.emit()
			
		if pressed and not has_started:
			press_strength = strength
			has_started = true
			started.emit()
			
		elif not pressed and not success_hit:
			execute(press_strength * strength)
			success_hit = true
			hit.emit()
			
	func next_player_beat() -> int:
		if not has_started:
			return start_beat
		else:
			return hit_beat
		pass

signal failed
signal completed

signal activated_action
signal hit_action

var combo : Combo

var active_action : ActionLifecycle:
	set(value):
		active_action = value
		if value != null:
			value.completed.connect(_on_action_completed)
			value.started.connect(_on_action_start)
			value.failed.connect(_on_action_failed)
			value.hit.connect(_on_action_hit)

var action_queue = []

var is_charging = false

var press_strength = 0

var next_beat = 0

@onready var beat_manager = get_tree().get_first_node_in_group("beat_manager")
# Called when the node enters the scene tree for the first time.
func _ready():
	beat_manager.beat.connect(_on_beat)
	
	var offset = beat_manager.beat_number
	
	for slot in range(combo.amount_of_slots):
		var action = combo.actions[slot]
		var lc
		if action.is_hold_action:
			lc = HoldActionLifecycle.new(self, action, offset)
		else:
			lc = ActionLifecycle.new(self, action, offset)
			
		action_queue.append(lc)
		offset = lc.end_beat
	
	print (action_queue)
	active_action = action_queue.pop_front()
	pass # Replace with function body.	

func _input(event: InputEvent):
	if event.is_action_pressed("rhythm_hit"):
		var sync = beat_manager.get_sync_amount(active_action.next_player_beat())
		active_action.rhythm_hit(sync, true)
	
	if event.is_action_released("rhythm_hit"):
		var sync = beat_manager.get_sync_amount(active_action.next_player_beat())
		active_action.rhythm_hit(sync, false)
		print("release sync ", sync)
		

func _on_beat(beat_number: int):
	if active_action:
		active_action.process_beat(beat_number)
	pass

func _on_action_hit():
	print("hit ", active_action.action.action_name)
	hit_action.emit()
	pass
func _on_action_start():
	print("started ", active_action.action.action_name)
	pass

func _on_action_completed():
	print("completed ", active_action.action.action_name)
	active_action = action_queue.pop_front()
	if active_action != null:
		print('asdfasdfasdf')
		activated_action.emit(active_action)
	pass
	
func _on_action_failed():
	print("failed ", active_action.action.action_name)
	failed.emit()
	pass
