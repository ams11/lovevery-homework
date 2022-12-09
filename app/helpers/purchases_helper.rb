module PurchasesHelper
  private

  def child_params(base_params: params.require(:order))
    begin
      birthdate = Date.parse(base_params[:child_birthdate])
    rescue ArgumentError
      birthdate = nil
    end
    {
      full_name: base_params[:child_full_name],
      parent_name: base_params[:shipping_name],
      birthdate: birthdate,
    }
  end

  def credit_card_params(base_params: params.require(:order))
    base_params.permit(:credit_card_number, :expiration_month, :expiration_year)
  end
end
