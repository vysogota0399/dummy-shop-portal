class AddressesController < AuthorizedController
  def create
    current_user.addresses.create(create_params)

    redirect_to root_path
  end

  def show
    
  end

  private
  def create_params
    params.require(:address).permit(:address, :front_door, :floor, :intercom)
  end
end
