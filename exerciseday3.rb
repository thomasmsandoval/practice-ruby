require "sqlite3"
require "tty-table"

db = SQLite3::Database.open "car.db"
db.execute "CREATE TABLE IF NOT EXISTS car(id INTEGER PRIMARY KEY, make TEXT, color TEXT, price INTEGER, stock Integer)"

while true
  system "clear"
  results = db.query "SELECT * FROM car"
  header = ["type", "color", "price", "stock"]
  rows = results.to_a
  table = TTY::Table.new header, rows
  puts "CAR (#{rows.length} total)"
  puts table.render(:unicode)
  puts
  print "[C]reate [R]ead [U]pdate [D]elete [Q]uit: "
  input_choice = gets.chomp.downcase
  if input_choice == "c"
    print "Make: "
    input_make = gets.chomp
    print "Color: "
    input_color = gets.chomp
    print "Price: "
    input_price = gets.chomp.to_i
    db.execute "INSERT INTO cars (make, color, price, stock) VALUES (?, ?, ?, ?)",
               input_make, input_color, input_price, 1
  elsif input_choice == "r"
    print "Car id: "
    input_id = gets.chomp.to_i
    results = db.query "SELECT * FROM cars WHERE id = ?", input_id
    first_result = results.next
    puts "Id: #{first_result[0]}"
    puts "Make: #{first_result[1]}"
    puts "Model: #{first_result[2]}"
    puts "Price: #{first_result[3]}"
    puts "Stock: #{first_result[4]}"
    puts
    print "Press enter to continue"
    gets.chomp
  elsif input_choice == "u"
    print "Car id: "
    input_id = gets.chomp.to_i
    print "Update stock status (true or false): "
    input_active = gets.chomp
    if input_active == "true"
      input_active = 1
    else
      input_active = 0
    end
    db.execute "UPDATE car SET active = ? WHERE id = ?", input_stock, input_id
  elsif input_choice == "d"
    puts "Delete car"
    print "Enter car id: "
    input_id = gets.chomp.to_i
    db.execute "DELETE FROM car WHERE id = ?", input_id
  elsif input_choice == "q"
    system "clear"
    puts "Goodbye!"
    return
  else
    puts "Invalid choice"
    print "Press enter to continue"
    gets.chomp
  end
end
