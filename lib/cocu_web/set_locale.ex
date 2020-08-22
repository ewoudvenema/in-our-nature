defmodule CocuWeb.SetLocale do

    @locales ~w{en es nl pt}

    def init(opts), do: opts

    def call(conn, _opts) do
        case conn.path_info do
            [locale | rest] when locale in @locales ->
                %{conn | path_info: rest, request_path: String.replace_prefix(conn.request_path, "/" <> locale,"")}
                |> Plug.Conn.assign(:locale, locale)
            _  ->
                conn
        end
    end
end