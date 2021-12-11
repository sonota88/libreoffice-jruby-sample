require "faraday"

puts "cell_set =>"
res = Faraday.post(
  "http://localhost:4567/calc",
  {
    file: "./sample.fods", sheet: "Sheet1",
    command: "cell_set",
    col: 0, row: 2, val: Time.now.to_s
  }
)

puts res.body

puts "cell_get =>"
res = Faraday.post(
  "http://localhost:4567/calc",
  {
    file: "./sample.fods", sheet: "Sheet1",
    command: "cell_get",
    col: 0, row: 2
  }
)

puts res.body

puts "dump =>"
res = Faraday.post(
  "http://localhost:4567/calc",
  {
    file: "./sample.fods", sheet: "Sheet1",
    command: "dump"
  }
)

puts res.body
