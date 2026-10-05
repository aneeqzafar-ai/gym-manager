class MembershipsController < ApplicationController
  def new
    @member=Member.find(params[:member_id])
    @membership=@member.memberships.build(start_date: Date.today, end_date: 1.month.from_now.to_date)
  end

  def create
    @member=Member.find(params[:member_id])

    @membership=@member.memberships.build(membership_params)

    if @membership.save
      redirect_to member_path(@member), notice: "Membership successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @member=Member.find(params[:member_id])
    @membership=@member.memberships.find(params[:id])
  end

  def update
    @member=Member.find(params[:member_id])
    @membership=@member.memberships.find(params[:id])

    if @membership.update(membership_params)
      redirect_to member_path(@member), notice: "Membership successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def membership_params
    params.expect(membership: [:start_date, :end_date, :amount])
  end
end
