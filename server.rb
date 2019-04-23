require "erb"
require "sqlite3"
require_relative "./lib/todo"

class Application
  def initialize
    @index = File.read "./views/index.html.erb"
    Todo.init(SQLite3::Database.new("./db"))
  end

  def call(env)
    req = Rack::Request.new(env)
    res = Rack::Response.new

    case req.env["REQUEST_METHOD"]
    when "GET"
      todos = Todo.list
      res.write ERB.new(@index).result(binding)
    when "POST"
      if req.POST["delete"]
        Todo.delete(req.POST["id"])
      else
        Todo.new(req.POST)
      end
      todos = Todo.list
      res.write ERB.new(@index).result(binding)
    end

    res.finish
  end
end
