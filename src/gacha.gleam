import player.{type Person, can_afford, change_coins}
import gleam/int
import gleam/dict.{type Dict, get}
import gleam/io

pub fn do_gacha(
  person: Person,
  inv: Dict(String, Int),
) -> #(Person, Dict(String, Int)) {
  let price = 20
  let #(person, inv) = case
    person
    |> can_afford(price)
  {
    True -> {
      // CAN AFFORD
      let inv = case pull_success() {
        True -> {
          inv
          |> add_item("Massive Honkers Woman")
        }
        False ->
          inv
          |> add_item("Pile of Shit")
      }
      let person = change_coins(person, price * -1)
      #(person, inv)
    }
    False -> {
      // CAN'T AFFORD
      io.println("You can't afford this bruh")
      #(person, inv)
    }
  }
  #(person, inv)
}

fn add_item(inv: Dict(String, Int), item_name: String) -> Dict(String, Int) {
  io.println("You pulled a " <> item_name)
  case
    inv
    |> get(item_name)
  {
    Ok(n) ->
      inv
      |> dict.insert(item_name, n + 1)
    Error(_) ->
      inv
      |> dict.insert(item_name, 1)
  }
}

fn pull_success() -> Bool {
  case int.random(200) {
    1 | 2 | 3 -> True
    _ -> False
  }
}
