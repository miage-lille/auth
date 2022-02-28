module E = Auth_lib.Infra.Environment
module A = Auth_lib.Api

let () =
  let () = Dream.initialize_log ~level:E.log_level () in
  Dream.run ~port:E.port
  @@ Dream.logger
  @@ Dream.sql_pool E.db_uri
  @@ Dream.router A.routes
