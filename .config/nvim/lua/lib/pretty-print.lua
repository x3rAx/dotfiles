local json_pretty_print = require("lib.third-party.json_pretty_print")

return function(data, compare, escape_special_chars)
  return json_pretty_print:pretty_print(data, compare, escape_special_chars)
end
