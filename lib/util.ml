module Result = struct
  include Result

  module Syntax = struct
    let ( let* ) = Result.bind
    let ( let+ ) = Result.map
  end

  module Infix = struct
    let ( >>= ) = Result.bind
    let ( >|= ) = Result.map
  end
end