defmodule InvoiceApp.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias InvoiceApp.Repo
  alias InvoiceApp.Accounts.Account
  alias InvoiceApp.Users.User
  alias InvoiceApp.Users
  alias InvoiceApp.Accounts.AccountUser

  @doc """
  Returns the list of accounts.
  ## Examples
      iex> list_accounts()
      [%Account{}, ...]
  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.
  Raises `Ecto.NoResultsError` if the Account does not exist.
  ## Examples
      iex> get_account!(123)
      %Account{}
      iex> get_account!(456)
      ** (Ecto.NoResultsError)
  """
  def get_account!(nil), do: nil
  def get_account!(id), do: Repo.get!(Account, id)

  def get_account_by_domain!(domain), do: Repo.get_by!(Account, domain: domain)
  def get_account_by_domain(domain), do: Repo.get_by(Account, domain: domain)

  def get_account_for_user(user) do
    from(a in Account,
      left_join: au in assoc(a, :accounts_users),
      where: au.user_id == ^user.id
    ) |> Repo.one!()
  end

  @doc """
  Creates a account.
  ## Examples
      iex> create_account(%{field: value})
      {:ok, %Account{}}
      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.
  ## Examples
      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}
      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Account.
  ## Examples
      iex> delete_account(account)
      {:ok, %Account{}}
      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}
  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.
  ## Examples
      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}
  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  def add_user(account, %{"role" => "admin"} = user) do
    add_user(account, user, true)
  end
  def add_user(account, user) do
    add_user(account, user, false)
  end
  def add_user(account, user, is_admin) do
    # Possible return values are
    #
    # error: something went wrong
    # created: User was new to system.
    # joined:  User was in system and has now been added to account
    # member:  User was already a member of account
    case get_or_invite_user(user) do
      {:error, changeset} -> {:error, changeset}
      {resp, user} ->
        case join_account_to_user(account, user, is_admin) do
          {:ok, %{id: nil}}   -> {:member, user}
          {:ok, _}            -> if resp == :exists, do: {:joined, user}, else: {:created, user}
          {:error, changeset} -> {:error, changeset}
        end
    end
  end
  def add_user(account_id, user_id) do
    %AccountUser{
      account_id: account_id,
      user_id: user_id,
      account_admin: false,
      active: true
    } |> Repo.insert()
  end

  defp get_or_invite_user(%{"email" => email} = user) do
    if existing_user = Users.get_user_by_email(email) do
      {:exists, existing_user}
    else
      Users.invite_user(user)
    end
  end

  defp join_account_to_user(account, user, is_admin) do
    %AccountUser{
      user_id:       user.id,
      account_id:    account.id,
      active:        true,
      account_admin: is_admin
    }
    |> Repo.insert(
      on_conflict: :nothing,
      conflict_target: [:account_id, :user_id]
    )
  end
end
