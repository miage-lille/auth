let hello_handler _request =
  let open Yojson.Safe in
  Dream.json @@ to_string @@ `Assoc [("message", `String "hello world")]

let routes = [Dream.get "/" hello_handler]
