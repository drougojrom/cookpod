defmodule Cookpod.Picture do
  use Arc.Definition
  use Arc.Ecto.Definition

  @versions [:original]

  def validate({file, _}) do
    ~w(.jpg .jpeg .gif .png) |> Enum.member?(Path.extname(file.file_name))
  end

  def __storage, do: Arc.Storage.Local
end
