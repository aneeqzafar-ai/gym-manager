class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    @user=User.new
  end

  def create
    if params[:user][:password] != params[:user][:password_again]
      flash.now[:alert]="Passwords do not match"

      @user=User.new(email_address: params[:user][:email_address])

      render :new, status: :unprocessable_entity
    else
      @user=User.new(user_params)

      if @user.save
        redirect_to new_session_path, notice: "Thank you for signing up!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  private
  def user_params
    params.expect(user: [:email_address, :password])
  end
end
