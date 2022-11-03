# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InvoiceApp.Repo.insert!(%InvoiceApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias InvoiceApp.Repo
alias InvoiceApp.Users.User
alias InvoiceApp.Accounts.Account
alias InvoiceApp.Accounts.AccountUser
alias InvoiceApp.SeedHelpers

Repo.delete_all(AccountUser)
Repo.delete_all(User)
Repo.delete_all(Account)

demo_account = SeedHelpers.add_account("Demo Account", "example.com")

users = [
  %{
    name: "Nick Fury",
    email: "nickFury@example.com",
    is_admin: true
  },
  %{
    name: "Steve Rogers",
    email: "capt@example.com",
    is_admin: false
  },
  %{
    name: "Tony Stark",
    email: "iron_man@example.com",
    is_admin: false
  },
  %{
    name: "Peter Parker",
    email: "spiderWeb@example.com",
    is_admin: false
  }
]

Enum.each(users, &SeedHelpers.add_user_and_join_account(demo_account, &1))

customers = [
  %{
    name: "Acme Corp",
    email: "acme@example.com"
  },
  %{
    name: "Wayne Enterprises",
    email: "batman@example.com"
  },
  %{
    name: "Wonka Industries",
    email: "candyMan@example.com"
  }
]

Enum.each(customers, &SeedHelpers.add_customer(demo_account, &1.name, &1.email))

invoices = [
  [
    %{
      name: "Tire replacement",
      description: "Replacement of front left tire",
      total: 275.60
    },
    %{
      name: "Brake service",
      description: "Replacement of front and rear break lines",
      total: 2500.00
    },
    %{
      name: "Service fee",
      description: "Labor: 5 hours at $145/hr",
      total: 725.00
    }
  ],
  [
    %{
      name: "Foundation repair & cleanup",
      description: "Excavation and replacement of concrete foundation",
      total: 10000.75
    },
    %{
      name: "Machine labor",
      description: "Labor: 8.5 hours at $150/hr",
      total: 1275.00
    }
  ],
  [
    %{
      name: "Flooring removal",
      description: "Removal and disposal of existing hardwood floor",
      total: 832.00
    },
    %{
      name: "Flooring installation",
      description: "Installation of new hardwood floor. Price includes particle board sub-floor and finish",
      total: 1900.33
    },
    %{
      name: "6mo warranty",
      description: "Warranty against issues directly resulting from flooring installation.",
      total: 125.40
    },
    %{
      name: "Service fee",
      description: "Labor: 10 hours at $70/hr",
      total: 700.00
    }
  ],
  [
    %{
      name: "Website creation",
      description: "Corporate website creation",
      total: 25000.00
    },
    %{
      name: "Logo design",
      description: "Corporate logo design and trademark",
      total: 7330.45
    }
  ],
  [
    %{
      name: "Transportation",
      description: "Bus transportation from JFK airport to company retreat on Staten Island",
      total: 1975.23
    },
    %{
      name: "Tent rental",
      description: "Rental of 2 corporate tents for 5 hours at $850/hr",
      total: 8500.00
    },
    %{
      name: "Catering",
      description: "Lunch, drinks, and snacks provided for 30 guests",
      total: 1425.00
    },
    %{
      name: "Service fee",
      description: "After event cleanup and tent damage repair",
      total: 493.00
    }
  ]
]

Enum.each(invoices, &SeedHelpers.add_invoice_and_line_items(demo_account, length(users), length(customers), &1))
