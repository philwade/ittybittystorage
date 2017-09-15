defmodule Ittybitty.BitController do
  use Ittybitty.Web, :controller
  alias Ittybitty.Bit
  require Logger
  @recaptcha_api Application.get_env(:ittybitty, :recaptcha_api)

  def show(conn, %{"id" => id}) do
    case Ittybitty.Store.get_key(id) do
      {:ok, value} ->
        json conn, %{value: value}
      {:notfound} ->
            put_status(conn, 404)
            |> render(Ittybitty.ErrorView, "404.json")
    end
  end

  def update(conn, %{"id" => key, "value" => value}) do
    case Ittybitty.Store.update_key(key, value) do
      {:notfound} ->
        put_status(conn, 404)
        |> render(Ittybitty.ErrorView, "404.json")
      {:invalid} ->
        put_status(conn, 403)
        |> render(Ittybitty.ErrorView, "403.json")
      {:ok, val} ->
        Task.Supervisor.start_child(Ittybitty.DbSupervisor, fn -> Ittybitty.AsyncDB.update_key(key) end)
        json conn, %{value: value}
    end
  end

  def update(conn, %{"id" => _}) do
    put_status(conn, 403)
    |> render(Ittybitty.ErrorView, "403.json")
  end


  def verify(conn, params) do
    case @recaptcha_api.verify(params["g-recaptcha-response"]) do
      {:ok, _} ->
        changeset = Bit.changeset(%Bit{ value: true })
        case Repo.insert(changeset) do
          {:ok, bit} ->
            key = bit.id
            create_key(key, conn)
          {:error, _changeset} ->
            put_status(conn, 500)
            |> render(Ittybitty.ErrorView, "500.html")
        end
      {:error, errors} ->
        Enum.map(validation_errors(errors), fn(error) ->
          Logger.error fn ->
            "Error during recaptcha validation: #{error}"
          end
        end)
        render conn, "new.html", errors: errors
    end
  end

  defp validation_errors(errors) do
    Enum.map(errors, fn(error) ->
      case error do
        :missing_input_response -> "The response parameter is missing."
        :missing_input_secret -> "The secret parameter is missing."
        :invalid_input_secret -> "The secret parameter is invalid or malformed."
        :invalid_input_response -> "The response parameter is invalid or malformed."
        :bad_request -> "The request is invalid or malformed."
        _ -> "Unkown validation error"
      end
    end)
  end

  defp create_key(key, conn) do
    case Ittybitty.Store.create_key(key) do
      {:ok, _} ->
        render conn, "verify.html", key: key
      {:error, _msg} ->
        put_status(conn, 500)
        |> render(Ittybitty.ErrorView, "500.html")
    end
  end

  def new(conn, _params) do
    render conn, "new.html", errors: nil
  end
end
