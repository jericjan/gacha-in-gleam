import player.{type Person, can_afford, change_coins}
import gleam/int
import gleam/dict.{type Dict, get}
import gleam/io
import gleam/option.{type Option, Some}

pub type WonGacha =
  Bool

/// if given haxx_status, keep pulling until gacha won
pub fn do_gacha(
  person: Person,
  inv: Dict(String, Int),
  haxx_status: Option(WonGacha),
) -> #(Person, Dict(String, Int)) {
  let price = case haxx_status {
    Some(_) -> {
      0
    }
    _ -> {
      20
    }
  }
  let #(person, inv, won) = case
    person
    |> can_afford(price)
  {
    True -> {
      // CAN AFFORD
      let #(inv, won) = case pull_success() {
        True -> {
          let new_inv =
            inv
            |> add_item("Massive Honkers Woman")
          #(new_inv, True)
        }
        False -> {
          let new_inv =
            inv
            |> add_item("Pile of Shit")
          #(new_inv, False)
        }
      }
      let person = change_coins(person, price * -1)
      #(person, inv, won)
    }
    False -> {
      // CAN'T AFFORD
      io.println("You can't afford this bruh")
      #(person, inv, False)
    }
  }
  case #(haxx_status, won) {
    #(Some(_), False) -> {
      do_gacha(person, inv, Some(False))
    }
    _ -> {
      #(person, inv)
    }
  }
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
