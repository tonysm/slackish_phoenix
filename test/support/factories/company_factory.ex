defmodule SlackishPhoenix.CompanyFactory do
  defmacro __using__(_opts) do
    quote do
      def company_factory do
        %SlackishPhoenix.Companies.Company{
          name: "madewithlove"
        }
      end
    end
  end
end
