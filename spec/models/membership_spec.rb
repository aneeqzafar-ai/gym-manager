require "rails_helper"

RSpec.describe Membership, type: :model do
  let(:member) { Member.new(name: "Ahmed") }
  let(:attributes) do
    { start_date: Date.today, end_date: 1.month.from_now.to_date, amount: 50000 }
  end

  describe "validations" do
    it "is valid with a start_date, end_date, and amount" do
      membership = member.memberships.build(attributes)

      expect(membership).to be_valid
    end

    it "is invalid without a start_date" do
      membership = member.memberships.build(attributes.merge(start_date: nil))

      expect(membership).not_to be_valid
      expect(membership.errors[:start_date]).to include("can't be blank")
    end

    it "is invalid without an end_date" do
      membership = member.memberships.build(attributes.merge(end_date: nil))

      expect(membership).not_to be_valid
      expect(membership.errors[:end_date]).to include("can't be blank")
    end

    it "is invalid without an amount" do
      membership = member.memberships.build(attributes.merge(amount: nil))

      expect(membership).not_to be_valid
      expect(membership.errors[:amount]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "is invalid without a member" do
      membership = Membership.new(attributes)

      expect(membership).not_to be_valid
      expect(membership.errors[:member]).to include("must exist")
    end

    it "belongs to a member" do
      member.save!
      membership = member.memberships.create!(attributes)

      expect(membership.reload.member).to eq(member)
    end
  end
end
