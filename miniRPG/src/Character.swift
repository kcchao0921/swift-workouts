typealias AttackFunc = (Character, Character) -> ()	//function type

//define error
enum CharacterActionError: ErrorProtocol {
	case deadBody(attacker: Character)
}

enum AnsiColor : String {
	case black = "30"
	case red = "31"
	case green = "32"
	case yellow = "33"

	func paint(_ string: String) ->String {
		return "\u{001B}[1;" + self.rawValue + "m" + string + "\u{001B}[0m"
	}
}

class Character {
	var name: String
	var hp: Int
	var strength: Int
	var weapon: Weapon!
	var power: Int {
		get {
			if weapon != nil {
				return strength + weapon.strength
			}

			return strength
		}
	}

	init(_ name: String, hp: Int, strength: Int ,_ weapon: Weapon! = nil) {
		self.name = name
		self.hp = hp
		self.strength = strength
		self.weapon = weapon
	}

	subscript(index: String) -> Int {
		get {
			switch(index) {
			case "hp":
				return hp
			default:
				return -1
			}
		}
		set(newValue) {
			switch(index) {
				case "hp":
					hp = newValue
				default:
					break;
			}
		}
	}

	func attack(_ target: Character, way: AttackFunc? = nil) throws {
		guard target.hp > 0 else {
			throw CharacterActionError.deadBody(attacker: self)
		}

		//nested function
		func normalAttack(_ attaker: Character, _ target: Character) {
			if (weapon != nil) {
				print("\(AnsiColor.green.paint(name)) uses \(weapon.name) to attack \(AnsiColor.red.paint(target.name)).")
			} else {
				print("\(AnsiColor.green.paint(name)) attacks \(AnsiColor.red.paint(target.name)).")
			}
		}

		let attackWay = way ?? normalAttack
		attackWay(self, target)
		target.attackedBy(self)
	}

	@discardableResult
	func attackedBy(_ attacker: Character) -> Int {

		guard hp > 0 else {
			return 0
		}

		let lostHp = attacker.power
		hp -= lostHp

		return lostHp
	}
}

//custom operators
infix operator => {associativity left}

@discardableResult
func => (left: Character, right: Character) throws -> Character {
	if left.hp > 0 {
		try left.attack(right)
	}

	return right
}
