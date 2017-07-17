defmodule Ittybitty.BitControllerTest do
  use Ittybitty.ConnCase

  test "GET /newbit", %{conn: conn} do
    conn = get conn, "/newbit"
    assert html_response(conn, 200) =~ "Almost there"
  end

  test "POST /newbit failure", %{conn: conn} do
    conn = post conn, "/newbit", %{"g-recaptcha-response": "bad"}
    assert html_response(conn, 200) =~ "Sorry, something has gone wrong"
  end

  test "POST /newbit success", %{conn: conn} do
    conn = post conn, "/newbit", %{"g-recaptcha-response": "good"}
    assert html_response(conn, 200) =~ "Here you go!"
  end

  test "PUT /api/bit failure", %{conn: conn} do
    conn = put conn, "/api/bit/notarealbit", %{"value" => 1}
    assert json_response(conn, 404) == %{"error" => "not found"}
  end
end

defmodule Ittybitty.StubRecaptcha do
  def verify(response) do
    case response do
      "bad" -> {:error, %{}}
      "good" -> {:ok, %{}}
    end
  end
end

