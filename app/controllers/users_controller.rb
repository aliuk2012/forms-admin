class UsersController < ApplicationController
  after_action :verify_authorized
  after_action :verify_policy_scoped, only: :index

  rescue_from ActiveRecord::RecordNotFound do
    render template: "errors/not_found", status: :not_found
  end

  def index
    authorize current_user, :can_manage_user?
    render template: "users/index", locals: { users: policy_scope(User) }
  end

  def edit
    authorize current_user, :can_manage_user?
    user
  end

  def update
    authorize current_user, :can_manage_user?

    if user.update(user_params)
      user.update_user_forms
      redirect_to users_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

private

  def user_params
    params.require(:user).permit(:has_access, :role, :organisation_id)
  end

  def user
    @user ||= User.find(params[:id])
  end
end
