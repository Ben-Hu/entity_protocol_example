defmodule Entity.Behaviour do
  @callback init(struct()) :: {:ok, struct()} | {:error, term()}
  @callback init!(struct()) :: struct()
  @callback update(struct(), keyword() | map()) :: {:ok, struct()} | {:error, term()}
  @callback update!(struct(), keyword() | map()) :: struct()

  defmacro __using__(_opts) do
    quote do
      @behaviour unquote(__MODULE__)

      @impl unquote(__MODULE__)
      def init(entity), do: unquote(__MODULE__).__init__(entity)

      @impl unquote(__MODULE__)
      def init!(entity), do: unquote(__MODULE__).__init__!(entity)

      @impl unquote(__MODULE__)
      def update(entity, opts), do: unquote(__MODULE__).__update__(entity, opts)

      @impl unquote(__MODULE__)
      def update!(entity, opts), do: unquote(__MODULE__).__update__!(entity, opts)

      defoverridable unquote(__MODULE__)
    end
  end

  def __init__(entity), do: {:ok, entity}

  def __init__!(%{__struct__: module} = entity) do
    case module.init(entity) do
      {:ok, entity} -> entity
      {:error, reason} -> raise ArgumentError, inspect(reason)
    end
  end

  def __update__(entity, opts) when is_list(opts) do
    __update__(entity, Map.new(opts))
  end

  def __update__(%{__struct__: module} = entity, opts) do
    module
    |> struct!(Map.merge(Map.from_struct(entity), opts))
    |> module.init()
  end

  def __update__!(%{__struct__: module} = entity, opts) do
    case module.update(entity, opts) do
      {:ok, updated} -> updated
      {:error, reason} -> raise ArgumentError, inspect(reason)
    end
  end
end
