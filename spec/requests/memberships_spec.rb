require "rails_helper"

RSpec.describe "Memberships", type: :request do
  fixtures :users

  let(:member) { Member.create!(name: "Ahmed") }
  let(:valid_params) do
    { membership: { start_date: Date.today, end_date: 1.month.from_now.to_date, amount: 50000 } }
  end

  context "when not logged in" do
    it "redirects the new form to the login page" do
      get new_member_membership_path(member)

      expect(response).to redirect_to(new_session_path)
    end
  end

  context "when logged in" do
    before do
      post session_path, params: { email_address: users(:one).email_address, password: "password" }
    end

    describe "GET /members/:member_id/memberships/new" do
      it "renders the new form" do
        get new_member_membership_path(member)

        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /members/:member_id/memberships" do
      it "creates a membership and redirects to the member" do
        expect {
          post member_memberships_path(member), params: valid_params
        }.to change(member.memberships, :count).by(1)

        expect(response).to redirect_to(member_path(member))
      end

      it "does not create a membership with invalid params" do
        invalid_params = { membership: { start_date: nil, end_date: nil, amount: nil } }

        expect {
          post member_memberships_path(member), params: invalid_params
        }.not_to change(Membership, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end

    describe "GET /members/:member_id/memberships/:id/edit" do
      it "renders the edit form" do
        membership = member.memberships.create!(valid_params[:membership])

        get edit_member_membership_path(member, membership)

        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /members/:member_id/memberships/:id" do
      it "updates the membership and redirects to the member" do
        membership = member.memberships.create!(valid_params[:membership])

        patch member_membership_path(member, membership), params: { membership: { amount: 70000 } }

        expect(membership.reload.amount).to eq(70000)
        expect(response).to redirect_to(member_path(member))
      end

      it "does not update with invalid params" do
        membership = member.memberships.create!(valid_params[:membership])

        patch member_membership_path(member, membership), params: { membership: { amount: nil } }

        expect(membership.reload.amount).to eq(50000)
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
