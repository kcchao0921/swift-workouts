func getUserChoice(max: Int) -> (Int, Int) {
	var method = 0
	var target = 0

	repeat {
		print("1.sword\n2.magic\nchoose the attacking way:")

		if let userInput = readLine() {
			method = Int(userInput) ?? 0
		}
	} while (method < 1) || (method > 2)

	repeat {
		print("choose the target(1 - \(max)):")

		if let userInput = readLine() {
			target = Int(userInput) ?? 0
		}
	} while (target < 1) || (target > max)

	return (method, target)
}

extension Hero {
	func match(_ monsters: inout [Monster]) {
		//cleanup action, will be called at last
		defer {
			if hp > 0 {
				print("Battle is over.")
			}
		}

		//error handling
		do {
			while (hp > 0) && !monsters.isEmpty {
				print(AnsiColor.yellow.paint("********************"))
				for (index, monster) in monsters.enumerated() {
					print("\(index + 1). \(monster.name)")
				}
				print(AnsiColor.yellow.paint("********************"))
				var (method, target) = getUserChoice(max: monsters.count)
				print("------------")
				target -= 1

				if method == 1 {
					//use custom operator
					try self => monsters[target]
				} else {
					try attack(monsters[target], way: magicAttack)
				}
				if (monsters[target].hp <= 0) {
					monsters.remove(at: target)
				}

				for monster in monsters {
					try monster.attack(self)
					if(hp <= 0) {
						break
					}
				}
			}
		} catch CharacterActionError.deadBody(let attacker) {
			print("oops! \(attacker.name) attacks dead body")
		} catch {
			print("shouldn't be here!")
		}
	}
}

//optional variable
var hero: Hero? = Hero("Arthur", hp: 100, strength: 5, Weapon(name: "Excalibur", strength: 100))

//array
var monsters = [
	Monster("Slime", hp: 2, strength: 2),
	Monster("Goblin", hp: 5, strength: 3, Weapon(name: "club", strength: 2)),
	Monster("Chimera", hp: 10, strength: 7),
	Monster("Death Lancer", hp: 105, strength: 10, Weapon(name: "spear", strength: 5))
]

if let h = hero {
	h.match(&monsters)
	if(h["hp"] <= 0) {
		hero = nil //this will let destructor of Hero be called
	}
}
