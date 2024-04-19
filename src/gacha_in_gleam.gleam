import gleam/io
import gleam/erlang
import player.{type Person, Person, change_coins, change_sanity}
import gleam/string
import gleam/int
import gleam/dict.{type Dict}
import gacha.{do_gacha}
import gleam/list
import gleam/option.{None, Some}

pub fn main() {
  io.println(
    "Welcome to Kur0's Epic Gacha! (Written in Gleam)\n" <> "Let's begin",
  )
  let name = get_name()

  let player = Person(name: name, sanity: 100, coins: 0)
  let inventory = dict.new()
  greet(player, inventory)
}

fn show_menu(person: Person, inv: Dict(String, Int)) -> Nil {
  show_stats(person)
  io.println(
    "(1) Grind (-10 Sanity, +10 Coins)\n"
    <> "(2) Rest (+5 Sanity)\n"
    <> "(3) Gacha (-20 Coins)\n"
    <> "(4) Check Inventory\n"
    <> "(5) Exit\n",
  )
  let #(choice, is_haxxor) = get_int_input("Pick a number: ")

  let #(person, inv, end) = case is_haxxor {
    True -> {
      io.println("Welcome back, haxxor man!")
      let #(person, inv) = do_gacha(person, inv, Some(False))
      #(person, inv, False)
    }
    False -> {
      case choice {
        1 -> {
          io.println("Grinding!")
          let p =
            change_coins(person, 10)
            |> change_sanity(-10)

          #(p, inv, False)
        }
        2 -> {
          io.println("Resting!")
          #(change_sanity(person, 5), inv, False)
        }
        3 -> {
          io.println("Gacha-ing!")
          let #(person, inv) = do_gacha(person, inv, None)
          #(person, inv, False)
        }
        4 -> {
          let inv = get_inv(inv)
          #(person, inv, False)
        }
        5 -> {
          #(person, inv, True)
        }
        _ -> {
          io.println("That's not one of the choices!")
          #(person, inv, False)
        }
      }
    }
  }

  case end {
    True -> {
      io.println("You're going already? Well, see ya next time!")
    }
    False -> {
      case person.sanity {
        x if x <= 0 ->
          io.println(person.name <> " has run out of sanity. Goodbye.")
        _ -> show_menu(person, inv)
      }
    }
  }
}

fn get_inv(inv: Dict(String, Int)) -> Dict(String, Int) {
  let li =
    inv
    |> dict.to_list()

  case list.length(li) {
    0 -> {
      io.println(
        "Your inventory is empty, brother. Do some gacha to fill it up!",
      )
    }
    _ -> {
      io.println("\n============\n")
      li
      |> list.each(fn(x) {
        let #(name, amount) = x
        io.println(
          name
          <> " : "
          <> amount
          |> int.to_string(),
        )
      })
      io.println("\n============\n")
    }
  }

  inv
}

fn get_int_input(msg: String) -> #(Int, Bool) {
  case erlang.get_line(msg) {
    Ok(n) -> is_int(n, fn() { get_int_input(msg) })
    Error(_) -> {
      io.println("Invalid input!")
      get_int_input(msg)
    }
  }
}

fn is_int(str: String, restart_func: fn() -> #(Int, Bool)) -> #(Int, Bool) {
  case
    str
    |> string.trim()
  {
    "hax" -> #(0, True)
    _ -> {
      let res =
        str
        |> string.trim()
        |> int.parse()
      case res {
        Ok(n) -> #(n, False)
        Error(_) -> {
          io.println("That's not a number!")
          restart_func()
        }
      }
    }
  }
}

fn get_name() -> String {
  case erlang.get_line("Enter your name: ") {
    Ok(n) ->
      n
      |> string.trim()
    Error(_) -> "Unknown"
  }
}

fn greet(person: Person, inv: Dict(String, Int)) -> Nil {
  io.println(
    "Hello there " <> person.name <> "! Let's start a new adventure!\n",
  )
  show_menu(person, inv)
}

fn show_stats(person: Person) -> Nil {
  io.println(
    "You have "
    <> person.sanity
    |> int.to_string()
    <> " sanity and "
    <> person.coins
    |> int.to_string()
    <> " cash.",
  )
}
