import Foundation

typealias AttackFunc = (Character, Character) -> ()	//function type

//define error
enum CharacterActionError: ErrorProtocol {
	case deadBody(attacker: Character)
}

enum AnsiColor: Int {
	case black = 30
	case red = 31
	case green = 32
	case yellow = 33
	case blue = 34
	case purple = 35
	case cyan = 36
	case white = 37

	func paint<T>(_ string: T) -> String {
		return "\u{001B}[1;\(self.rawValue)m\(string)\u{001B}[0m"
	}

	//generic function
	func paintBackground<T>(_ string: T) -> String {
		return "\u{001B}[1;\(self.rawValue + 10)m\(string)\u{001B}[0m"
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

	//this funciton throws an error
	func attack(_ target: Character, way: AttackFunc? = nil) throws {
		/*early exit
		  If the guard statement’s condition is met, code execution continues after the guard statement’s closing brace.
		  If that condition is not met, the code inside the else branch is executed.
		*/
		guard target.hp > 0 else {
			//throws error
			throw CharacterActionError.deadBody(attacker: self)
		}

		//nested function
		func normalAttack(_ attaker: Character, _ target: Character) {
			if (weapon != nil) {
				print("\(AnsiColor.cyan.paint(name)) uses \(AnsiColor.green.paintBackground(weapon.name)) to attack \(AnsiColor.red.paint(target.name)).")
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

		let time = UInt32(NSDate().timeIntervalSinceReferenceDate)
		srand(time)
		var lostHp = attacker.power
		if(attacker.power > 4) {
			lostHp += random() % (attacker.power / 2) - attacker.power / 4
		}
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
