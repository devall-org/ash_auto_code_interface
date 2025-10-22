# Rules for working with AshAutoCodeInterface

## Purpose

AshAutoCodeInterface automatically generates code interfaces for all actions in an Ash resource, reducing boilerplate when defining code interfaces.

## When to Use

- Resources with many actions that need code interfaces
- When most actions only need basic code interfaces without custom args
- When you want to define custom code interfaces for only a few actions manually

## Usage

Add the extension to your resource:

```elixir
defmodule MyApp.Post do
  use Ash.Resource,
    domain: MyApp.Blog,
    extensions: [AshAutoCodeInterface]

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
    
    read :get do
      get_by :id
    end
  end

  # Manually define code interfaces that need custom args
  code_interface do
    define :create, args: [:title, :body]
  end

  # Auto-generate code interfaces for the rest
  auto_code_interface do
    except [:destroy]  # Exclude specific actions
  end
end
```

This will generate:
- `MyApp.Post.create(title, body, ...)` - manually defined
- `MyApp.Post.get(params, ...)` - auto-generated
- `MyApp.Post.read(params, ...)` - auto-generated
- `MyApp.Post.update(params, ...)` - auto-generated
- No interface for `:destroy` - excluded

## How It Works

- Generates code interfaces for all actions not already defined in `code_interface` block
- Skips actions listed in `except` option
- Works with all action types (read, create, update, destroy, generic actions)

## Options

### `except`

Excludes specific actions from auto-generation. Accepts an atom or list of atoms.

```elixir
auto_code_interface do
  except [:destroy, :archive]
end
```

## Best Practices

- Define custom code interfaces with `args` manually in `code_interface` block
- Use `auto_code_interface` for actions that work fine with default interfaces
- Use `except` for actions that shouldn't have code interfaces at all

