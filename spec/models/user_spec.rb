require "rails_helper"

RSpec.describe User, type: :model do
  describe "email normalization" do
    it "strips whitespace and downcases the email address" do
      user = User.new(email_address: "  Test@Example.COM ")

      expect(user.email_address).to eq("test@example.com")
    end
  end

  describe "has_secure_password" do
    it "is invalid without a password" do
      user = User.new(email_address: "new@example.com")

      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "authenticates with the correct password" do
      user = User.create!(email_address: "new@example.com", password: "secret123")

      expect(user.authenticate("secret123")).to eq(user)
    end

    it "does not authenticate with a wrong password" do
      user = User.create!(email_address: "new@example.com", password: "secret123")

      expect(user.authenticate("wrong")).to be(false)
    end
  end

  describe "associations" do
    it "has many sessions and destroys them with the user" do
      user = User.create!(email_address: "new@example.com", password: "secret123")
      user.sessions.create!(user_agent: "rspec", ip_address: "127.0.0.1")

      expect { user.destroy }.to change(Session, :count).by(-1)
    end
  end
end
