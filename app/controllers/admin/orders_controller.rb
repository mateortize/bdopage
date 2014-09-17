class Admin::OrdersController < Admin::BaseController
  set_tab :orders

  def index
    @orders = current_account.orders.order("created_at desc")

    # render layout: false
  end

  def new
    selected_plan = Order::PLANS[params[:plan]]
    if selected_plan
      current_account.check_upgrade_plan!(selected_plan)
      @order = current_account.orders.build plan_type: params[:plan]
      @order.calculate_prices
      @order.build_billing_address
    else
      render 'select_plan'
    end

  rescue => ex
    flash.now[:alert] = ex.message
    render 'select_plan'
  end

  def create
    @order = Order.new(order_params)
    @order.account = current_account
    @order.payment_method = 'inatec'
    @order.calculate_prices

    begin
      current_account.check_upgrade_plan!(@order.plan)
    rescue => ex
      redirect_to new_admin_order_path, alert: ex.message
      return
    end

    if @order.valid? && @order.check_credit_card_validation && @order.create_payment!
      redirect_to admin_orders_path, notice: 'Your order is created.'
    else
      Rails.logger.debug { @order && @order.errors.to_hash.inspect }
      flash.now[:alert] = 'Sorry, payment is failed. Please try it again'
      render 'new'
    end
  end
  
  private

  def order_params
    params.fetch(:order, {})
          .permit(:number, :year, :month, :verification_value, :plan_type,
                  billing_address_attributes: [:id, :address_1, :address_2, :city, :state, :postal_code, :country_code])
          .merge({ip: request.remote_ip})
  end
end
