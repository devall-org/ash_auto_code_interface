# AshAutoCodeInterface

Automatically generates code_interface for ash resources' actions.

## Installation

Add `ash_auto_code_interface` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ash_auto_code_interface, "~> 0.1.0"}
  ]
end
```

## Usage


```elixir
defmodule Post do
  use Ash.Resource, domain: Domain, data_layer: Ash.DataLayer.Ets, extensions: [AshAutoCodeInterface]

  ets do
    private? true
  end

  attributes do
    uuid_primary_key :id

    attribute :title, :string, allow_nil?: false, public?: true
    attribute :tag, :string, allow_nil?: true, public?: true
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]

    read :get do
      get_by :id
    end
  end

  code_interface do
    define :create, args: [:title, :tag]
  end

  auto_code_interface do
    except [:destroy]
  end
end

# Defined by code_interface
 post = Post.create!("Hello", "greeting")

# Defined by auto_code_interface
 assert %{title: "Hello", tag: "greeting"} = Post.get!(%{id: post.id})
 assert [%{title: "Hello", tag: "greeting"}] = Post.read!()
```

## License

MIT