require "rails_helper"

RSpec.describe "Members", type: :request do
  fixtures :users

  context "when not logged in" do
    it "redirects the index to the login page" do
      get members_path

      expect(response).to redirect_to(new_session_path)
    end
  end

  context "when logged in" do
    before do
      post session_path, params: { email_address: users(:one).email_address, password: "password" }
    end

    describe "GET /members" do
      it "returns the member index" do
        get members_path

        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /members/:id" do
      it "shows the member" do
        member = Member.create!(name: "Ahmed")

        get member_path(member)

        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /members/new" do
      it "renders the new form" do
        get new_member_path

        expect(response).to have_http_status(:ok)
      end
    end

    describe "GET /members/:id/edit" do
      it "renders the edit form" do
        member = Member.create!(name: "Ahmed")

        get edit_member_path(member)

        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /members" do
      it "creates a member and redirects to it" do
        expect {
          post members_path, params: { member: { name: "Ahmed" } }
        }.to change(Member, :count).by(1)

        expect(response).to redirect_to(member_path(Member.last))
      end

      it "does not create a member with invalid params" do
        expect {
          post members_path, params: { member: { name: "" } }
        }.not_to change(Member, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "PATCH /members/:id" do
      it "updates the member and redirects to it" do
        member = Member.create!(name: "Ahmed")

        patch member_path(member), params: { member: { name: "Ali" } }

        expect(member.reload.name).to eq("Ali")
        expect(response).to redirect_to(member_path(member))
      end

      it "does not update with invalid params" do
        member = Member.create!(name: "Ahmed")

        patch member_path(member), params: { member: { name: "" } }

        expect(member.reload.name).to eq("Ahmed")
        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "DELETE /members/:id" do
      it "destroys the member and redirects to the index" do
        member = Member.create!(name: "Ahmed")

        expect {
          delete member_path(member)
        }.to change(Member, :count).by(-1)

        expect(response).to redirect_to(members_path)
      end
    end
  end
end
