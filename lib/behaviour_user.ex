defmodule BehaviourUser do
  use Entity.Behaviour

  @enforce_keys [:email, :username]
  defstruct id: nil,
            email: nil,
            username: nil,
            timezone: "Etc/UTC"

  def init(%__MODULE__{email: email}) when not is_binary(email) do
    {:error, {:invalid_opts, [:email]}}
  end

  def init(%__MODULE__{username: username}) when not is_binary(username) do
    {:error, {:invalid_opts, [:username]}}
  end

  def init(%__MODULE__{id: nil} = entity) do
    init(%{entity | id: Base.encode16(:crypto.strong_rand_bytes(8))})
  end

  def init(%__MODULE__{} = entity) do
    {:ok, entity}
  end
end
