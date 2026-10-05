---
name: rspec-conventions
description: Conventions for writing RSpec tests in the gym_manager Rails app (models, request specs, auth, fixtures). Use whenever adding or editing files under spec/.
---

# RSpec conventions for gym_manager

## Project facts
- Rails 8.1, SQLite, `rspec-rails`. Capybara/selenium are installed but there are no system specs yet.
- Domain: `Member` has_many `Membership`s (`/members/:member_id/memberships`). `User` and `Session` come from the Rails auth generator.
- `ApplicationController` includes `Authentication`, so **every route requires login** unless the controller calls `allow_unauthenticated_access` (only `SessionsController` and `PasswordsController` do).
- Validations: `Member` requires `name`. `Membership` requires `start_date`, `end_date`, `amount` and belongs to a member.
- Run with `bundle exec rspec` (a single file: `bundle exec rspec spec/requests/member_spec.rb`). `.rspec` only requires `spec_helper`, so each spec file must `require "rails_helper"` itself.

## File layout
| What | Where | `type:` |
|---|---|---|
| Model validations/associations | `spec/models/<model>_spec.rb` | `:model` |
| Controller behavior (HTTP) | `spec/requests/<resource>_spec.rb` | `:request` |
| View helpers | `spec/helpers/<name>_helper_spec.rb` | `:helper` |

- Prefer **request specs** over controller specs. Don't add `spec/controllers`.
- Always declare `type:` explicitly on the top-level `RSpec.describe`.
- Remove or fill in `pending "add some examples..."` placeholders (see `user_spec.rb`, `memberships_spec.rb`, `memberships_helper_spec.rb`) when touching those files.

## Authentication in request specs
Any request to a protected route needs a logged-in user, otherwise it returns a **302 redirect to `new_session_path`**. Log in through the real sessions endpoint:

```ruby
RSpec.describe "Members", type: :request do
  fixtures :users

  before do
    post session_path, params: { email_address: users(:one).email_address, password: "password" }
  end
  ...
end
```

- Fixture users live in `spec/fixtures/users.yml`: `one@example.com` and `two@example.com`, password `"password"`. These are test-DB only, unrelated to dev data.
- Each example gets a fresh cookie jar and transactional rollback, so no explicit logout is needed. Only `delete session_path` when testing logout itself.
- Test the unauthenticated case in its own `context` without the login and expect `redirect_to(new_session_path)`.
- If the same login is needed in several files, extract it to `spec/support/` (e.g. a `sign_in(user)` helper) and uncomment the `Rails.root.glob('spec/support/**/*.rb')` line in `rails_helper.rb`.

## Data setup
- Users: use fixtures (`fixtures :users`).
- Members and memberships have no fixtures. Build them inline in the example or a `let`, using the association: `member.memberships.build(...)` / `create`. Use `Date.today` / `1.month.from_now.to_date` for dates and a plain number for `amount`.
- Prefer `build`/`new` for validation specs (no DB hit) and `create` only when the record must persist (show/edit/update/destroy requests).
- Don't depend on fixture or DB state left by another example. `use_transactional_fixtures = true` rolls back after each one.

## Style
- One behavior per `it`, with a descriptive sentence: `it "is invalid without a name"`.
- Group with `describe "GET /members"` / `context "when not logged in"`.
- Use the `Arrange → Act → Assert` layout with blank lines between phases.
- Use the modern `expect(...).to` syntax and `have_http_status(:ok)` / `:redirect` / `:unprocessable_entity` rather than numeric codes.
- Use `be_valid` / `be_invalid` plus `errors[:field]` for validations:
  ```ruby
  member = Member.new(name: nil)
  expect(member).not_to be_valid
  expect(member.errors[:name]).to include("can't be blank")
  ```
- Match the existing codebase formatting (2-space indent, spaces after `=` and commas) even though some older specs omit them.

## What to cover
- **Models:** each presence validation (valid and invalid case), `has_many`/`belongs_to` behavior, and `User` email normalization (`strip` + `downcase`) and `has_secure_password`.
- **Requests, per action:** success path, redirect target after create/update/destroy, `:unprocessable_entity` with invalid params, and the unauthenticated redirect.
- **Params:** members take `member: { name: }`; memberships take `membership: { start_date:, end_date:, amount: }`. Controllers use `params.expect`, so a missing top-level key returns 400 rather than raising.

## Known gotchas
- `rails_helper` does not auto-load `spec/support`. Enable it before relying on shared helpers.
- `spec_helper.rb` has random ordering, `disable_monkey_patching!`, and `focus` filtering commented out. Don't assume they're active, and write order-independent specs anyway.
