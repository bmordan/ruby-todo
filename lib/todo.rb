require "sqlite3"

class Todo
  attr_reader :id, :task, :status

  @@db

  def initialize(todo)
    if todo.key?("id")
      # update task
      @id = todo["id"]
      @status = todo["status"]
      @@db.execute("UPDATE todos SET status=? WHERE id IS ?", [@status, @id])
      update
    else
      # new task
      @@db.execute("INSERT INTO todos (task, status) VALUES (?, 0);", todo["task"])
      @id = @@db.last_insert_row_id.to_s
      @status = 0
      @@all_todos << self
    end

    @task = todo["task"]
  end

  def update
    index = @@all_todos.index { |todo| todo.id == @id }
    unless index.nil?
      @@all_todos[index] = self
    end
  end

  def self.init(db)
    @@db = db
    @@db.execute("CREATE TABLE IF NOT EXISTS todos (id INTEGER PRIMARY KEY, task TEXT, status INTEGER);")
    @@all_todos = @@db.execute("SELECT * FROM todos;").map { |row|
      self.new({ id: row[0], task: row[1], status: row[2] })
    }
  end

  def self.list
    @@all_todos
  end

  def self.delete(id)
    index = @@all_todos.index { |todo| todo.id == id }
    unless index.nil?
      @@all_todos.delete_at(index)
      @@db.execute("DELETE FROM todos WHERE id IS ?", id)
    end
  end
end
