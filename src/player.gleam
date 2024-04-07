pub type Person {
  Person(name: String, sanity: Int, coins: Int)
}

pub fn change_coins(person: Person, amount: Int) -> Person {
  Person(person.name, person.sanity, person.coins + amount)
}

pub fn change_sanity(person: Person, amount: Int) -> Person {
  Person(person.name, person.sanity + amount, person.coins)
}

pub fn can_afford(person: Person, price: Int) -> Bool {
  case person.coins {
    x if x < price -> False
    _ -> True
  }
}
