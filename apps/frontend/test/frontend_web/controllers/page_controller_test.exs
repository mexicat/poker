defmodule FrontendWeb.PageControllerTest do
  use FrontendWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Ye Olde Poker"
  end
end
