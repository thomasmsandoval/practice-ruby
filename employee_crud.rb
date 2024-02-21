require "sqlite3"
require "tty-table"

db = SQLite3::Database.open "employee.db"
db.execute "CREATE TABLE IF NOT EXISTS employees(id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, salary INTEGER, active INTEGER)"

while true
  system "clear"
  results = db.query "SELECT * FROM employees"
  header = ["id", "first_name", "last_name", "salary", "active"]
  rows = results.to_a
  table = TTY::Table.new header, rows
  puts "EMPLOYEES (#{rows.length} total)"  # printing Employees with the number of total employees in the terminal
  puts table.render(:unicode) # Creates comands for the table in the terminal
  puts
  print "[C]reate [R]ead [U]pdate [D]elete [Q]uit: " # These are the command we choose from to enter data in the terminal
  input_choice = gets.chomp.downcase
  if input_choice == "c" # Creates an employee
    print "First name: " # Asks user to enter the first name of the employee
    input_first_name = gets.chomp # This is where we type the first name of the employee
    print "Last name: " # This asks user to enter the last name
    input_last_name = gets.chomp # This is where we type the employees last name
    print "Salary: " # Asks user to enter employees salary
    input_salary = gets.chomp.to_i # This is wehere we enter the salary number
    db.execute "INSERT INTO employees (first_name, last_name, salary, active) VALUES (?, ?, ?, ?)",
               input_first_name, input_last_name, input_salary, 1  # This is the employee info that prints into the table
  elsif input_choice == "r" # If our choice is read the employee the folowing will print to the terminal
    print "Employee id: " # Employee id prints to the terminal
    input_id = gets.chomp.to_i  # This is where we enteer the employee id
    results = db.query "SELECT * FROM employees WHERE id = ?", input_id # This shows the results of the employee id the user entered
    first_result = results.next
    puts "Id: #{first_result[0]}"  # This prints out the employee id in the tabel
    puts "First name: #{first_result[1]}"  # This prints out the employees first name in the table
    puts "Last name: #{first_result[2]}" # This prints out the employee last name in the table
    puts "Salary: #{first_result[3]}" # This prints out the employees salary
    puts "Active: #{first_result[4]}" # This prints out the employees active status
    puts
    print "Press enter to continue" # This instructs the user to Press enter to continue in the terminal
    gets.chomp  # Not sure what this gets.chomp is for. May be the action of pressing enter
  elsif input_choice == "u" # this puts us in the loop if we select update
    print "Employee id: " # This asks the user to input the employee id in the terminal
    input_id = gets.chomp.to_i  # This is where the user enters in the employee id
    print "Update active status (true or false): "  # Prints Update active status in the terminal
    input_active = gets.chomp # User enters the status of the employee
    if input_active == "true" # This is the loop we enter after entering employee status.
      input_active = 1  # If status is true 1 will print in the table
    else
      input_active = 0 # if status is false 0 will print in the table
    end
    db.execute "UPDATE employees SET active = ? WHERE id = ?", input_active, input_id
  elsif input_choice == "d"
    puts "Delete employee"
    print "Enter employee id: "
    input_id = gets.chomp.to_i
    db.execute "DELETE FROM employees WHERE id = ?", input_id
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
