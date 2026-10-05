class MembersController < ApplicationController

  before_action :set_member, only: [:show, :edit, :update, :destroy]
  def index
    @members=Member.all
  end

  def show
    #debugger
    @member=Member.find(params[:id])
  end

  def edit
    @member=Member.find(params[:id])
  end

  def new
    @member=Member.new
  end

  def create
    # p "member_params: #{member_params}"
    # debugger
    @member=Member.new(member_params)

    if @member.save
      redirect_to @member
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @member=Member.find(params[:id])

    if @member.update(member_params)
      redirect_to @member
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @member=Member.find(params[:id])
    @member.destroy
    redirect_to members_path
  end

  private

  def set_member
    @member=Member.find(params[:id])
  end
  def member_params
    params.expect(member: [:name])
  end
end
