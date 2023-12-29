module Customers
  class RegistrationsController < Devise::RegistrationsController
    protected

    def redirect_home_with_alert_message
      redirect_to root_path
    end

    def sign_up_params
      params.require(:customer).permit(
        :name, :email, :password, :password_confirmation,
      )
    end

    def account_update_params
      params.require(:customer).permit(:name, :email, :current_password, :password, :password_confirmation)
    end
  end
end
