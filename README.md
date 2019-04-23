[![TODOS](https://user-images.githubusercontent.com/4499581/56571380-b7949f00-65b4-11e9-8394-944ff93b0105.jpg)](http://todo.whitechapeau.com)

This is a simple todo app that uses:

* rack
* erb
* SQLite3

To run this locally clone this repo, install and run like this:

```sh
bundle install
```

```sh
rackup
```

Then you can visit `http://loclahost:9292` and see your todo list.

## SQLite3

The app is set up to persist the todo list in the `db` file that you can see in the root of the project. I found it helpful when developing to use the in memory SQLite3 db which you can set like this in the `server.rb` file.

```ruby
  def initialize
    @index = File.read "./views/index.html.erb"
    Todo.init(SQLite3::Database.new(":memory:"))
  end
```

## Dockerfile

Build a docker image or pull from docker hub [`bmordan/ruby-todo`](https://hub.docker.com/r/bmordan/ruby-todo
)