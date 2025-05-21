defmodule AshAutoCodeInterface.Transformer do
  use Spark.Dsl.Transformer
  alias Spark.Dsl.Transformer

  def before?(_), do: false
  def after?(_), do: true

  def transform(dsl_state) do
    resource = Transformer.get_persisted(dsl_state, :module)
    except = dsl_state |> Transformer.get_option([:auto_code_interface], :except) |> List.wrap()
    actions = Transformer.get_entities(dsl_state, [:actions])

    validate_except(resource, except, actions)

    actions
    |> Enum.reject(&(&1.name in except))
    |> Enum.reduce({:ok, dsl_state}, fn action, {:ok, dsl_state} ->
      dsl_state |> Ash.Resource.Builder.add_new_interface(action.name, [])
    end)
  end

  def validate_except(resource, except, actions) do
    for name <- except, not Enum.any?(actions, &(&1.name == name)) do
      raise "Cannot exclude action #{name} as it does not exist in #{resource |> inspect()}."
    end
  end
end
