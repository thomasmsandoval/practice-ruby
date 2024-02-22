require "sqlite3"   # Requires gem sqlite 3
require "tty-table"  # Requires gem tty-table

class Employee # Creates Employee class
  @@db = SQLite3::Database.open "employee.db"
  @@db.execute "CREATE TABLE IF NOT EXISTS employees(id INTEGER PRIMARY KEY, first_name TEXT, last_name TEXT, salary INTEGER, active INTEGER)" # Creates employee table if the table does not exist

  attr_reader :id, :first_name, :last_name, :active, :salary  # These are the attributes that can only be read
  attr_writer :active # These attributes can be written by the user

  def initialize(input_options) # Initializes the class
    @id = input_options[:id] # This identifies @id as the input id
    @first_name = input_options[:first_name] # This identifies @first_name as the input first_name
    @last_name = input_options[:last_name] # This identifies @last_name as the input last_name
    @salary = input_options[:salary] # this identifies @salary as the input salary
    @active = input_options[:active] # this identifies @active as the input active option
  end

  def self.create(options) # This creates the table with the below inputs
    @@db.execute "INSERT INTO employees (first_name, last_name, salary, active) VALUES (?, ?, ?, ?)", # this creates the headers in the table and sets to values for the headers to an unknown
                 options[:first_name], options[:last_name], options[:salary], options[:active]  # Inputs that will appear in the table
  end

  def self.all # This pushes all the employees info to the table
    results = @@db.query "SELECT * FROM employees"
    results.map do |row|
      Employee.new(id: row[0], first_name: row[1], last_name: row[2], salary: row[3], active: row[4])
    end
  end

  def self.find_by(options) # Used to select an emplouee by the id number
    results = @@db.query "SELECT * FROM employees WHERE id = ?", options[:id]
    first_result = results.next
    Employee.new(id: first_result[0], first_name: first_result[1], last_name: first_result[2], salary: first_result[3], active: first_result[4])
  end

  def update(options) # allows user to input whether employee is 1 active or 0 inactive
    if options[:active] == "true"
      active = 1
    else
      active = 0
    end
    @@db.execute "UPDATE employees SET active = ? WHERE id = ?", active, self.id
  end

  def destroy # displays when delete is selected
    @@db.execute "DELETE FROM employees WHERE id = ?", self.id
  end
end

class View # Class for setting up the table
  def self.display_employees(employees)
    header = ["id", "first name", "last name", "salary", "active"]
    rows = employees.map { |employee| [employee.id, employee.first_name, employee.last_name, employee.salary, employee.active] }
    table = TTY::Table.new header, rows
    puts "EMPLOYEES (#{rows.length} total)"
    puts table.render(:unicode)
    puts
  end

  def self.display_employee(employee) # Displays text when the read command is selected
    puts "Id: #{employee.id}"
    puts "First name: #{employee.first_name}"
    puts "Last name: #{employee.last_name}"
    puts "Salary: #{employee.salary}"
    puts "Active: #{employee.active}"
    puts
    print "Press enter to continue"
    gets.chomp
  end

  def self.display_exit_screen # Displays what user sees when clicking enter to leave
    system "clear"
    puts "Goodbye!"
  end

  def self.display_error_screen # What user sees when selecting something other than options given
    puts "Invalid choice"
    print "Press enter to continue"
    gets.chomp
  end

  def self.get_menu_option # Navigation menu that user sees
    print "[C]reate [R]ead [U]pdate [D]elete [Q]uit: "
    gets.chomp.downcase
  end

  def self.get_create_options # Menu user sees when create is selected
    print "First name: "
    input_first_name = gets.chomp
    print "Last name: "
    input_last_name = gets.chomp
    print "Salary: "
    input_salary = gets.chomp.to_i
    { first_name: input_first_name, last_name: input_last_name, salary: input_salary, active: 1 }
  end

  def self.get_read_options # What user sees when read is selected
    print "Employee id: "
    input_id = gets.chomp.to_i
    { id: input_id }
  end

  def self.get_update_options # what user sees when update is selected
    print "Employee id: "
    input_id = gets.chomp.to_i
    print "Update active status (true or false): "
    input_active = gets.chomp
    { id: input_id, active: input_active }
  end

  def self.get_destroy_options # gives ability for user to delete
    puts "Delete employee"
    print "Enter employee id: "
    input_id = gets.chomp.to_i
    { id: input_id }
  end
end

class Controller # class for the program that will run all commands and display data
  def self.run
    while true
      system "clear"
      employees = Employee.all
      View.display_employees(employees)
      input_choice = View.get_menu_option
      if input_choice == "c"
        input_options = View.get_create_options
        Employee.create(input_options)
      elsif input_choice == "r"
        input_options = View.get_read_options
        employee = Employee.find_by(input_options)
        View.display_employee(employee)
      elsif input_choice == "u"
        input_options = View.get_update_options
        employee = Employee.find_by(id: input_options[:id])
        employee.update(input_options)
      elsif input_choice == "d"
        input_options = View.get_destroy_options
        employee = Employee.find_by(input_options)
        employee.destroy
      elsif input_choice == "q"
        View.display_exit_screen
        return
      else
        View.display_error_screen
      end
    end
  end
end

Controller.run # Executes the program
