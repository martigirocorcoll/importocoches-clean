class TelephoneController < ApplicationController
  skip_before_action :check_telephone_required

  def show
    redirect_to root_path if current_user.telephone.present?
  end

  def update
    if current_user.update(telephone_params)
      flash[:success] = t('pages.complete_telephone.success')
      redirect_to root_path
    else
      flash.now[:error] = t('pages.complete_telephone.error')
      render :show
    end
  end

  private

  def telephone_params
    params.require(:user).permit(:telephone)
  end
end