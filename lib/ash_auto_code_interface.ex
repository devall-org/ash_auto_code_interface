defmodule AshAutoCodeInterface do
  @auto_code_interface %Spark.Dsl.Section{
    name: :auto_code_interface,
    describe: """
    Automatically generates code_interface for all actions except those specified in except.
    """,
    examples: [
      """
      auto_code_interface do
        except [:create, :update]
      end
      """
    ],
    schema: [
      except: [
        type: {:wrap_list, :atom},
        required: false,
        default: [],
        doc: "Actions to exclude from code_interface generation"
      ]
    ],
    entities: []
  }

  use Spark.Dsl.Extension,
    sections: [@auto_code_interface],
    transformers: [AshAutoCodeInterface.Transformer]
end
