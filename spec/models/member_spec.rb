require "rails_helper"

RSpec.describe Member, type: :model do
  describe "validations" do
    it "is valid with a name" do
      member = Member.new(name: "Ahmed")

      expect(member).to be_valid
    end

    it "is invalid without a name" do
      member = Member.new(name: nil)

      expect(member).not_to be_valid
      expect(member.errors[:name]).to include("can't be blank")
    end

    it "is invalid with a blank name" do
      member = Member.new(name: "")

      expect(member).not_to be_valid
      expect(member.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "has many memberships" do
      member = Member.create!(name: "Ahmed")
      first = member.memberships.create!(start_date: Date.today, end_date: 1.month.from_now.to_date, amount: 50000)
      second = member.memberships.create!(start_date: 1.month.from_now.to_date, end_date: 2.months.from_now.to_date, amount: 60000)

      expect(member.memberships).to contain_exactly(first, second)
    end
  end
end
