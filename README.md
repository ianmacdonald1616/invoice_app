# InvoiceApp

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Details

Log in using (or any other user created in 'seeds.exs'):
  * email: nickFury@example.com
  * password: password00

# Microsoft 365 (Outlook)

The Edgewise Outlook integration enables automatic tracking of all external email communications with leads and/or buyers for your affiliated projects. Once enabled, you do not need to send emails from Seller Central or CC/BCC Edgewise for your emails to be tracked. Emails synched from your Outlook account are stored as a `ProjectEmailMessage` and are visible on the lead, or buyer, profile pages.

## Grant permissions to third-party applications

Before establishing the connection, make sure an administrator has configured user consent settings in the Entra admin center.
> Note: For additional guidance, please review the Microsoft official documentation: [Configure user consent settings](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/configure-user-consent?pivots=portal#configure-user-consent-settings).

## Scopes

The following scopes are required to use this integration: `email`, `Mail.ReadWrite`, `Mail.Send`, `offline_access`, `openid`, `profile`, `User.Read`.
> Note: Please work with your Microsoft Office 365 administrator and IT team to ensure these privileges are granted to the Edgewise enterprise application.

## How to enable the Microsoft 365 Outlook integration
Edgewise uses the OAuth 2.0 protocol to authenticate with Microsoft. Complete the following steps to set up your Outlook integration.

1. From the **Account** dropdown menu, select **Integrations**.
2. Click **Microsoft** and **Install**.
3. An OAuth connection dialog modal will appear, prompting you to log in to your Microsoft account if required.
   - If Edgewise has been granted permission by an administrator, the dialog modal will close and you will be notified that the integration was successful.
   - If Edgewise has not been granted permission by an administrator, you will be prompted to request their approval.
       <img width="603" alt="Screenshot 2024-07-25 at 9 33 13 AM" src="https://github.com/user-attachments/assets/7dbf6b69-502d-43db-a3ec-448fab6d1f5c">
     - An Office 365 administrator will be notified of your request and can grant permission for you and all subsequent requests in the Microsoft Entra admin center.
       ![Screenshot 2024-07-25 at 9 27 59 AM](https://github.com/user-attachments/assets/1e67adf3-bb94-4616-afc2-1785f28f345b)
     - Once you have verified an administrator granted your request, repeat the integration steps above.
5. Your integration has been added.

> Note: In cases you encounter errors during the sign-in process, it is recommended you contact your Microsoft Office 365 administrator to ensure permission has been granted to the Edgewise application. If problems persist, please contact [support@edgewise.io](mailto:support@edgewise.io.
