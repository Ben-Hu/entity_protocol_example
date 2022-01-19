defprotocol Entity do
  def init(entity)
  def init!(entity)
  def update(entity, opts)
  def update!(entity, opts)
end

defmodule Entity.DefaultImpl do
  def __init__(entity), do: {:ok, entity}

  def __update__(entity, opts) when is_list(opts) do
    __update__(entity, Map.new(opts))
  end

  def __update__(%{__struct__: module} = entity, opts) do
    module
    |> struct!(Map.merge(Map.from_struct(entity), opts))
    |> Entity.init()
  end
end

defimpl Entity, for: Any do
  defmacro __deriving__(module, _struct, opts) do
    init = Keyword.get(opts, :init, &Entity.DefaultImpl.__init__/1)
    update = Keyword.get(opts, :update, &Entity.DefaultImpl.__update__/2)

    quote do
      defimpl Entity, for: unquote(module) do
        def init(entity), do: unquote(init).(entity)

        def init!(entity) do
          case unquote(init).(entity) do
            {:ok, entity} -> entity
            {:error, reason} -> raise ArgumentError, inspect(reason)
          end
        end

        def update(entity, opts), do: unquote(update).(entity, opts)

        def update!(entity, opts) do
          case unquote(update).(entity, opts) do
            {:ok, updated} -> updated
            {:error, reason} -> raise ArgumentError, inspect(reason)
          end
        end
      end
    end
  end

  defdelegate init(entity), to: Entity.DefaultImpl, as: :__init__

  def init!(entity) do
    case Entity.init(entity) do
      {:ok, entity} -> entity
      {:error, reason} -> raise ArgumentError, inspect(reason)
    end
  end

  defdelegate update(entity, opts), to: Entity.DefaultImpl, as: :__update__

  def update!(entity, opts) do
    case Entity.update(entity, opts) do
      {:ok, updated} -> updated
      {:error, reason} -> raise ArgumentError, inspect(reason)
    end
  end
end
