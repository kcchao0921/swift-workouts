func magicAttack(_ attacker: Character, _ target: Character) {
	print("[\(attacker.name)] use fire to attack \(target.name)")
}

class Hero: Character {
	//property observers
	override var hp: Int {
		willSet {
		}

		didSet {
			if hp > 0 {
				print("\(name) lost \(AnsiColor.red.paintBackground(oldValue - hp)) hp and remains \(hp) hp.")
			}
		}
	}

	override init(_ name: String, hp: Int, strength: Int, _ weapon: Weapon! = nil) {
		super.init(name, hp: hp, strength: strength, weapon)
		print("\(name) is on the way.")
	}

	deinit {
		print("\(name) is dead. The adventure is over.")
	}
}
