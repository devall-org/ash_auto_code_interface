defmodule AshAutoCodeInterface.Case do
  use ExUnit.Case, async: true

  alias __MODULE__.{Post, Domain}

  defmodule Post do
    use Ash.Resource,
      domain: Domain,
      data_layer: Ash.DataLayer.Ets,
      extensions: [AshAutoCodeInterface]

    ets do
      private? true
    end

    attributes do
      uuid_primary_key :id

      attribute :title, :string, allow_nil?: false, public?: true
      attribute :tag, :string, allow_nil?: true, public?: true
    end

    actions do
      defaults [:read, create: :*, update: :*]

      read :get do
        get_by :id
      end
    end

    code_interface do
      define :create, args: [:title, :tag]
    end

    auto_code_interface do
      except [:update]
    end
  end

  defmodule Domain do
    use Ash.Domain, validate_config_inclusion?: false

    resources do
      resource Post
    end
  end

  test "automatically defines code_interface for actions not manually defined in code_interface" do
    assert %{name: :read, args: [], get?: false} = Ash.Resource.Info.interface(Post, :read)

    # If get? of read action is true, it works the same as true even if get? of code interface is false
    assert %{name: :get, args: [], get?: false} = Ash.Resource.Info.interface(Post, :get)
  end

  test "skips actions manually defined in code_interface" do
    assert %{name: :create, args: [:title, :tag]} = Ash.Resource.Info.interface(Post, :create)
  end

  test "skips actions specified in except" do
    refute Ash.Resource.Info.interface(Post, :update)
  end

  test "run code_interface" do
    post = Post.create!("Hello", "greeting")
    assert %{title: "Hello", tag: "greeting"} = Post.get!(%{id: post.id})
    assert [%{title: "Hello", tag: "greeting"}] = Post.read!()
  end
end
